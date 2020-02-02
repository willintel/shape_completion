from util.torch_nn import PytorchNet, set_determinsitic_run
from dataset.datasets import PointDatasetMenu
from util.string_op import banner, set_logging_to_stdout
from util.func import tutorial
from util.torch_data import none_or_int
from test_tube import HyperOptArgumentParser
from architecture.models import F2PEncoderDecoder
from architecture.lightning import lightning_trainer, test_lightning
from dataset.transforms import *
from dataset.abstract import InCfg

set_logging_to_stdout()
set_determinsitic_run()  # Set a universal random seed


# ----------------------------------------------------------------------------------------------------------------------
#                                               Main Arguments
# ----------------------------------------------------------------------------------------------------------------------
def parser():
    p = HyperOptArgumentParser(strategy='random_search')
    # Check-pointing
    # TODO - Don't forget to change me!
    p.add_argument('--exp_name', type=str, default='', help='The experiment name. Leave empty for default')
    p.add_argument('--resume_version', type=none_or_int, default=None,
                   help='Try train resume of exp_name/version_{resume_version} checkpoint. Use None for no resume')
    p.add_argument('--save_completions', type=int, choices=[0, 1, 2], default=2,
                   help='Use 0 for no save. Use 1 for vertex only save in obj file. Use 2 for a full mesh save (v&f)')

    # Dataset Config:
    # NOTE: A well known ML rule: double the learning rate if you double the batch size.
    p.add_argument('--batch_size', type=int, default=10, help='SGD batch size')
    p.add_argument('--counts', nargs=3, type=none_or_int, default=(None, None, None),
                   help='[Train,Validation,Test] number of samples. Use None for all in partition')
    p.add_argument('--in_channels', choices=[3, 6, 12], default=6,
                   help='Number of input channels')

    # Train Config:
    p.add_argument('--force_train_epoches', type=int, default=1,
                   help="Force train for this amount. Usually we'd early stop using the callback. Use 1 to disable")
    p.add_argument('--lr', type=float, default=0.001, help='The learning step to use')

    # Optimizer
    p.add_argument("--weight_decay", type=float, default=0, help="Adam's weight decay - usually use 1e-4")
    p.add_argument("--plateau_patience", type=none_or_int, default=None,
                   help="Number of epoches to wait on learning plateau before reducing step size. Use None to shut off")
    p.add_argument("--early_stop_patience", type=int, default=100,
                   help="Number of epoches to wait on learning plateau before stopping train")
    # Without early stop callback, we'll train for cfg.MAX_EPOCHS

    # L2 Losses: Use 0 to ignore, >0 to compute
    p.add_argument('--lambdas', nargs=4, type=float, default=(1, 0.001, 0, 0, 0),
                   help='[XYZ,Normal,Moments,Euclid_Maps,FaceAreas] loss multiplication modifiers')
    # Loss Modifiers: # TODO - Implement for Euclid Maps & Face Areas as well.
    p.add_argument('--mask_penalties', nargs=3, type=float, default=(0, 0, 0),
                   help='[XYZ,Normal,Moments] increased weight on mask vertices. Use val <= 1 to disable')
    p.add_argument('--dist_v_penalties', nargs=3, type=float, default=(0, 0, 0),
                   help='[XYZ,Normal,Moments] increased weight on distant vertices. Use val <= 1 to disable')

    # Computation
    p.add_argument('--gpus', type=none_or_int, default=-1, help='Use -1 to use all available. Use None to run on CPU')
    p.add_argument('--distributed_backend', type=str, default='dp',
                   help='supports three options dp, ddp, ddp2')  # TODO - ddp2,ddp Untested
    p.add_argument('--use_16b', type=bool, default=False, help='If true uses 16 bit precision')  # TODO - Untested

    # Visualization
    p.add_argument('--use_tensorboard', type=bool, default=True,  # TODO - Not in use
                   help='Whether to log information to tensorboard or not')
    p.add_argument('--use_parallel_plotter', type=bool, default=True,
                   help='Whether to plot mesh sets while training or not')

    return [p]


# ----------------------------------------------------------------------------------------------------------------------
#                                                   Mains
# ----------------------------------------------------------------------------------------------------------------------
def train_main():
    banner('Network Init')
    nn = F2PEncoderDecoder(parser())
    nn.identify_system()

    hp = nn.hyper_params()
    # Init loaders and faces:
    ds = PointDatasetMenu.get('FaustPyProj', in_cfg=InCfg.FULL2PART, in_channels=hp.in_channels)
    ldrs = ds.split_loaders(split=[0.8, 0.1, 0.1], s_nums=hp.counts,
                            s_shuffle=[True] * 3, s_transform=[Center()] * 3, batch_size=hp.batch_size, device=hp.dev)
    nn.init_data(loaders=ldrs)

    trainer = lightning_trainer(nn, fast_dev_run=False)
    banner('Training Phase')
    trainer.fit(nn)
    banner('Testing Phase')
    trainer.test(nn)

def test_main():
    # Decide Model:
    # TODO - Fix this
    nn = F2PEncoderDecoder(parser())
    hp = nn.hyper_params()
    ds = PointDatasetMenu.get('DFaustPyProj', in_cfg=InCfg.FULL2PART, in_channels=hp.in_channels)
    test_ldr = ds._loader(ids=range(1000), transforms=None, batch_size=hp.batch_size, device=hp.dev)
    nn.init_data(loaders=[None, None, test_ldr])
    test_lightning(nn)



# ----------------------------------------------------------------------------------------------------------------------
#                                                 Tutorials
# ----------------------------------------------------------------------------------------------------------------------
@tutorial
def dataset_tutorial():
    # TODO - Fix Tutorial
    # Use the menu to see which datasets are implemented
    print(PointDatasetMenu.which())
    ds = PointDatasetMenu.get('FaustPyProj')  # This will fail if you don't have the data on disk
    ds.validate_dataset()  # Make sure all files are available - Only run this once, to make sure.
    banner('The HIT')
    ds.report_index_tree()  # Take a look at how the dataset is indexed - using the hit [HierarchicalIndexTree]

    banner('Collateral Info')
    print(f'Dataset Name = {ds.name()}')
    print(f'Number of available Point Clouds = {ds.num_pnt_clouds()}')
    print(f'Expected Input Shape for a single mesh = {ds.shape()}')
    print(f'Required disk space in bytes = {ds.disk_space()}')
    # You can also request a summary printout with:
    ds.data_summary(with_tree=False)  # Don't print out the tree again
    # For models with a single set of faces (SMPL or SMLR for example) you can request the face set directly:
    banner('Face Array')
    print(ds.faces())
    # You can ask for a random sample of the data, under your needed transformations:
    banner('Data sample')
    print(ds.sample(num_samples=1, transforms=[Center()]))
    # You can also ask for a simple loader, given by the ids you'd like to see.
    # Pass ids = None to index the entire dataset, form point_cloud = 0 to point_cloud = num_point_clouds -1
    my_loader = ds._loader(ids=None, transforms=[Center()], batch_size=16, device='cpu-single')

    # To receive train/validation splits or train/validation/test splits use:
    my_loaders = ds.split_loaders(split=[0.8, 0.1, 0.1], s_nums=[800, 100, 100],
                                  s_shuffle=[True] * 3, s_transform=[Center()] * 3, global_shuffle=True)
    # You'll receive len(split) dataloaders, where each part i is split[i]*num_point_clouds size. From this split,
    # s_nums[i] will be taken for the dataloader, and transformed by s_transform[i].
    # s_shuffle and global_shuffle controls the shuffling of the different partitions - see doc inside function

    # You can see part of the actual dataset with strategies 'spheres','mesh' or 'cloud'
    ds.show_sample(n_shapes=8, key='gt_part', strategy='cloud')


@tutorial
def pytorch_net_tutorial():
    # TODO - Fix Tutorial
    # What is it? PyTorchNet is a derived class of LightningModule, allowing for extended operations on it
    # Let's see some of them:

    nn = F2PEncoderDecoder()  # Remember that F2PEncoderDecoder is a subclass of PytorchNet
    nn.identify_system()  # Outputs the specs of the current system - Useful for identifying existing GPUs
    nn.summary(x_shape=(5, 6890, 3))
    banner('General Net Info')
    print(f'On GPU = {nn.ongpu()}')  # Whether the system is on the GPU or not. Will print False
    target_input_size = ((6890, 3), (6890, 3))
    nn.summary(print_it=True, batch_size=3, x_shape=target_input_size)
    print(f'Output size = {nn.output_size(x_shape=target_input_size)}')

    banner('Weight Print')
    nn.print_weights()
    nn.visualize(x_shape=target_input_size, frmt='pdf')  # Prints PDF to current directory

    # Let's say we have some sort of nn.Module network:
    banner('Some network from the net usecase')
    import torchvision
    nn = torchvision.models.resnet50(pretrained=False)
    # We can extend it's functionality at runtime with a monkeypatch:
    py_nn = PytorchNet.monkeypatch(nn)
    py_nn.summary(x_shape=(3, 28, 28), batch_size=64)


@tutorial
def shortcuts_tutorial():
    print("""
    Existing shortcuts are: 
    r = reconstruction
    b = batch
    v = vertex
    d = dict / dir 
    s = string or split 
    vn = vertex normals
    n_v = num vertices
    f = face / file
    n_f = num faces 
    fn = face normals 
    gt = ground truth
    tp = template
    i = index 
    p = path 
    fp = file path 
    dp = directory path 
    hp = hyper parameters 
    ds = dataset 
    You can also concatenate - gtrb = Ground Truth Reconstruction Batched  
    """)


if __name__ == '__main__':
    train_main()

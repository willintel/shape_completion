%Author: James W. Ryland
%June 14, 2012

function [ ] = help()
%HELP this function make a gui that allows a user to read about help topics
%
%   Help creates a simple figure with a listBox. Some of lines in the
%   listBox can be double clicked to lead to new text and updates of the
%   text in the text box.
    
    text = getTopicList();
    
    %disp(text);
    fig = figure('Name', 'Volumetric Help Window', 'NumberTitle', 'off', 'MenuBar', 'none', 'Position', [1 1 400 400]);
    displayBox = uicontrol('Parent', fig, 'Style', 'listbox', 'String', text, 'Position', [10 10 380 380],...
        'CallBack', @displayBox_CallBack);
    
    set(displayBox, 'FontSize', 14);
    
    
    function displayBox_CallBack(h, EventData)
        
        index = get(displayBox, 'Value');
        
        if strcmp(get(fig,'SelectionType'),'open')
           
            switch index
                case 1
                    text = getTopicList();
                case 6
                    text = getFMRIPreprocessing();
                case 7
                    text = getFMRICookbook();
                case 9
                    text = 'Link Success';
                case 10
                    text = getExplorerHelp();
                case 11
                    text = getLayerEditorHelp();
                case 12
                    text = getRotateEditorHelp();
                case 13
                    text = getScalingEditorHelp();
                case 14
                    text = getBooleanEditorHelp();
                case 15
                    text = getVolumeLayerEditorHelp();
                case 16
                    text = getShellLayerEditorHelp();
                case 17
                    text = getGradientLayerEditorHelp();
                case 19
                    text = getAboutVolumetric();
                
            end
            
            set(displayBox,'Value', 1, 'String', text);
            
        end
        
    end

end


function [text] = getTopicList()


    text = {'Welcome To Volumetric',...                     %1
            '  ',...
            'Click on a topic to read more',...             %3
            '  ',...
            'Help Process Topics',...                       %5
            '--fMRI Preprocessing Suggestions',...          %6
            '--fMRI CookBook',...                           %7
            '  ',...
            'Help Utilities Topics',...                     %9
            '--explore utility',...                         %10
            '--layer editor',...                            %11
            '--rotation editor',...                         %12
            '--scaling editor',...                          %13
            '--boolean editor',...                          %14
            '--volume layer editor',...
            '--shell layer editor',...
            '--gradient layer editor',...
            '',...
            '*About Volumetric',...
            };


end

function [text] = getFMRIPreprocessing()
                                                 %stop here
    text = {'<=Back to Topic List',...
            '',...
            '',...
            'FMRI Preprocessing Suggestings      ',...
            '',...
            '    This help section covers some   ',...
            'suggestions for FMRI preprocessing  ',...
            'for the purposes of creating        ',...
            'visualizations with Volumetric.     ',...
            '',...
            '',...
            'Poplular Programs and Utilities',...
            '',...
            'SPM preprocessing',...
            '    SPM is a free to researchers    ',...
            'MATLAB program that can do many     ',...
            'polpular and nescissary FMRI data   ',...
            'manipulations. For visualization    ',...
            'purposes the corregistration        ',...
            'and segmentation utilitys are quite ',...
            'usefull.',...
            '',...
            '',...
            'Important Terms',...
            '',...
            '--Corregistration: Reorienting and  ',...
            '  interpolating one volume of data  ',...
            '  or multiple volumes of data to    ',...
            '  overlap a reference volume.       ',...
            '',...
            '--Segmentation: spliting an         ',...
            '  anatomical MRI image into a set   ',...
            '  of volume masks usually marking   ',...
            '  physical land marks in the brain.  ',...
            '',...
            '',...
            'FMRI Visualization preprerations    ',...
            '',...
            '1)Perform any segmentations that are',...
            '  nescissary for the visualization  ',...
            '  for SPM 8 this is done by pressing',...
            '  the segment button and setting any',...
            '  nescissary parameters. The default',...
            '  tends to work quite well though.',...
            '  ',...
            '2)Corregister all BOLD or DTI       ',...
            '  condition .img''s to the          ',...
            '  the Anatomical data. For SPM 8    ',...
            '  select "Corregister Est & Reslice"',...
            '  and set the reference volume to be',...
            '  the anatomical file, and the      ',...
            '  source a representitive functional',...
            '  file. Set all other condition data',...
            '  as additional files to be resliced',...
            '',...
            '3)Now it is nescissary to open up',...
            '  Volumetric.',...
            '',...
            '4)Rotate all files required to make',...
            '  the visualization so that they   ',...
            '  are upright. This can be done    ',...
            '  visually in the Rotation Editor  ',...
            '  in a batch. ',...
            '',...
            '5)Your data should now be oriented ',...
            '  correctly to create a            ',...
            '  visualization                    ',...
            '',...
            '',...
            'Note:',...
            '    These suggestions are just good',...
            'rules of thumb and will work for   ',...
            'many projects, but FMRI work is    ',...
            'known for its diversity of methods,',...
            'any and all of these steps may have',...
            'to be adjusted to suit your',...
            'projects individual needs',...
            };
end

function [text] = getFMRICookbook()
    text = {'<= Back to Topic List',...
            '',...                               %stop here
            '',...
            'FMRI Cookbook',...
            '    This is a series of steps for  ',...
            'making several visualizations for  ',...
            'fmri: BOLD and DTI signales        ',...
            '',...
            '',...
            'BOLD Visualization 1               ',...
            '',...
            '--Enter into the Layer Editor      ',...
            '',...
            '--Create a volume layer and set the',...
            '  source to be a correctly oriented',...
            '  whitematter mask. Choose a dark  ',...
            '  color.',...
            '',...
            '--Create a shell layer and set the ',...
            '  source to be a correctly oriented',...
            '  union of a whitematter masks and ',...
            '  a grey matter mask. Change the   ',...
            '  color to a bright saturated color',...
            '  and turn the transparency very   ',...
            '  low.',...
            '',...
            '--Create any layer type and set    ',...
            '  the source correctly             ',...
            '  corregistered BOLD contrast or   ',...
            '  condition data. Be sure to set   ',...
            '  min selection value to something ',...
            '  that will exclude low amplitude  ',...
            '  noise if the data has not been   ',...
            '  cortically masked.',...
            '',...
            '--Create a Combined Rendering and  ',...
            '  adjust the transparency and color',...
            '  values to make image more clear. ',...
            '',...
            };

end

function [text] = getRotateEditorHelp()
    
    text = {'<= Back to Topic List',...
            '',...
            '',...
            'ROTATE EDITOR',...
            '    This utility allows the user to ',...
            'rotate a series of source volumes   ',...
            'for use in the layer editor         ',...
            '',...
            '--Load Reference Volume loads the   ',...
            '  reference volume and creates a    ',...
            '  visualization so that the user can',...
            '  see the affects of the rotations  ',...
            '  applied',...
            '',...
            '--Load Additional Volumes loads     ',...
            '  additional voluems in a batch to  ',...
            '  be rotated when the rotation is   ',...
            '  applied',...
            '',...
            '--Apply applies the rotation to the ',...
            '  reference volume and all          ',...
            '  additional volumes',...
            '',...
            '--Reset resets the rotation list',...
            '',...
            '--Prefix is the prefix that will be ',...
            '  added to filenames of the rotated ',...
            '  files',...
            '',...
            '--X,Y,Z +- allows the user to rotate',...
            '  the reference volume around each  ',...
            '  primary axis.',...
            };

end

function [text] = getScalingEditorHelp()
    
    text = {'<= Back to Topic List',...
            '',...
            '',...
            'SCALING EDITOR',...
            '    This editor interpolates a set  ',...
            'of source volumes to an approximate ',...
            'target voxel number.',...
            '',...
            '--Target Voxel Number sets the      ',...
            '  approximate target voxel number   ',...
            '',...
            '--Load reference Volume sets a      ',...
            '  reference volume whos dimensions  ',...
            '  will be displayed in next to      ',...
            '  Current Dimensions and its        ',...
            '  voxel count after the interpolation',...
            '  will be displayed next to projected',...
            '  voxel number',...
            '',...
            '--Load Additional Volumes lets the  ',...
            '  user load additional volumes to be',...
            '  interpolated to the desired       ',...
            '  approximate volume. Note: that if ',...
            '  these volumes do not match the    ',...
            '  reference volume in dimension they',...
            '  will not have the same interpolated',...
            '  dimensions as the interpolated     ',...
            '  reference volume.',...
            '',...
            '--Apply Interpolation will apply the ',...
            '  interpolation to the desired       ',...
            '  approximate volume to all of the   ',...
            '  additional volumes and the reference',...
            '',...
            '--Prefix is the prefix that will be  ',...
            '  added to filename of the new scaled',...
            '  files.',...
            };

end

function [text] = getBooleanEditorHelp()
    
    text = {'<= Back to Topic List',...
            '',...
            '',...
            'BOOLEAN VOLUME EDITOR',...
            '    This editor allows the user to  ',...
            'apply a boolean operation on volume ',...
            'selections from two different source',...
            'volumes.',...
            '',...
            '--Set source sets the input for the ',...
            '  the panel.',...
            '',...
            '--Max/Min sets value bounds that    ',...
            '  define the volume selected from   ',...
            '  the source.',...
            '',...
            '--Set Selection loads the slected   ',...
            '  volume defined by the source      ',...
            '  volume and the max and min bounds.',...
            '',...
            '--Union,Intersect,XOR determins     ',...
            '  which boolean operation will be   ',...
            '  performed.',...
            '',...
            '--Save will open a save window in   ',...
            '  order to save the product of the  ',...
            '  boolean operation.',...
            };

end

function [text] = getExplorerHelp()
    
    text = {'<= Back to Topic List',...
            '',...
            '',...
            'Volumetric Explorer',...
            '    Allows the user to explore a    ',...
            'vizualization created by volumetric.',...
            '',...
            '--Load Files loads a Color Alpha    ',...
            '  Volume file (.mat) and updates the',...
            '  exploration window',...
            '',...
            '--Selection Control allows the user ',...
            '  to adjust what is visable along   ',...
            '  the axis closest to the view axis ',...
            '  and what the output of the Crop & ',...
            '  interp button will be.',...
            '',...
            '--Selection View (Bars/None) tells  ',...
            '  the Exploration window to render  ',...
            '  or not to render the bounding bars',...
            '',...
            '--Interpolation Setting             ',...
            '  (None/Automatic)          ',...
            '  changes the interpolation method  ',...
            '  used when the Crop & Interp button',...
            '  is used.',...
            '      None does not apply an        ',...
            '  interpolation at all. Automatic   ',...
            '  will apply an interpolation       ',...
            '  specified by the target voxel num ',...
            '',...
            '--Alpha Correction Multiplier is a  ',...
            '  corrects the transparency of the  ',...
            '  product of the interpolation. This',...
            '  is helpfull because when a volume ',...
            '  is interpolated to a higher       ',...
            '  resolution it becomes more opaque ',...
            '  and the reverse is true of interps',...
            '  that lower the resolution.',...
            '  the alpha correction multiplier   ',...
            '  can help with this but is not a   ',...
            '  perfect solution.',...
            '',...
            };

end

function [text] = getLayerEditorHelp()

    text = {'<= Back to Topic List',...
            '',...
            '',...
            'LAYER EDITOR',...
            '    Layer Editor allows the user to ',...
            'construct a Color Alpha Volume      ',...
            'vizualization. This will be done by ',...
            'creating several three dimensional  ',...
            'layers overlayed on eachother.',...
            '',...
            '--The Layers panel shows the name of ',...
            '  the current layers and their      ',...
            '  dimensions.',...
            '',...
            '--New Layer creates a new layer and ',...
            '  opens the editor for that type of ',...
            '  layer',...
            '',...
            '--Delete layer deletes the selected ',...
            '  layer',...
            '',...
            '--Edit Layer opens the layer editor ',...
            '  for a layer.',...
            '',...
            '--Load Layers opens a set of layers ',...
            '  saved to a .mat file',...
            '',...
            '--Create Normal Preview Render opens',...
            '  a rendering that combines all of  ',...
            '  the layers into a single CAV      ',...
            '  visualization.',...
            '',...
            '--Save Layers save the layers to a  ',...
            '  .mat file that can be opened later',...
            '',...
            '--Save CAV Output saves the Color   ',...
            '  Alpha Volume created by combining ',...
            '  the layers. The colors are decided',...
            '  by a weighted average of the source',...
            '  colors weighted by transparency.',...
            '',...
            };
end

function [text] = getVolumeLayerEditorHelp()

    text = {'<= Back to Topic List',...
            '',...
            '',...
            '--VOLUME LAYER PROPERTIES           ',...
            '      This editor allows the user to',...
            '  create a Color Alpha Volume       ',...
            '  representation of a filled volume ',...
            '  with a specific color and         ',...
            '  transparency.',...
            '',...
            '--Set Source sets the source volume ',...
            '  from a .mat or .img file.         ',...
            '',...
            '--Max/Min sets the boundries that   ',...
            '  define a selected volume inside   ',...
            '  the dimesnoins of the source      ',...
            '  volume.',...
            '',...
            '--Set Selection sets the selected   ',...
            '  volume defined by the source and  ',...
            '  the max and min.',...
            '',...
            '--R,B,G,A Sliders manipulate the    ',...
            '  color and transparency value for  ',...
            '  the output of the layer.',...
            '    -R = Red',...
            '    -B = Blue',...
            '    -G = Green',...
            '    -A = Alpha/Opacity',...
            '',...
            '--Apply & Refresh will create the   ',...
            '  CAV representation based on the   ',...
            '  selected volume and color settings',...
            '  , and it updates the Layer editor ',...
            '  with this representation.',...
            '',...
            };

end

function [text] = getShellLayerEditorHelp()
    
    text = {'<= Back to Topic List',...
            '',...
            '',...
            '--VOLUME LAYER PROPERTIES           ',...
            '      This editor allows the user to',...
            '  create a Color Alpha Volume       ',...
            '  representation of a shell around a',...
            '  selected volume, with a user set  ',...
            '  color and transparency.',...
            '',...
            '--Set Source sets the source volume ',...
            '  from a .mat or .img file.         ',...
            '',...
            '--Max/Min sets the boundries that   ',...
            '  define a selected volume inside   ',...
            '  the dimesnoins of the source      ',...
            '  volume.',...
            '',...
            '--Set Selection sets the selected   ',...
            '  volume defined by the source and  ',...
            '  the max and min.',...
            '',...
            '--R,B,G,A Sliders manipulate the    ',...
            '  color and transparency value for  ',...
            '  the output of the layer.',...
            '    -R = Red',...
            '    -B = Blue',...
            '    -G = Green',...
            '    -A = Alpha/Opacity',...
            '',...
            '--Apply & Refresh will create the   ',...
            '  CAV representation based on the   ',...
            '  selected volume and color settings',...
            '  , and it updates the Layer editor ',...
            '  with this representation.',...
            '',...
            };
        
end

function [text] = getGradientLayerEditorHelp()
    text = {'<= Back to Topic List',...
            '',...
            '',...
            '  GRADIENT LAYER PROPERTIES',...
            '      Allows a user to construct a  ',...
            'mapping from the value range of part',...
            'of a source volume into color alpha ',...
            'space, then it maps the source      ',...
            'volume into a CAV representation    ',...
            'using the mapping.',...
            '',...
            '--Set Source sets the source volume ',...
            '  from a .mat or .img file.         ',...
            '',...
            '--Max/Min sets the boundries that   ',...
            '  define a selected volume inside   ',...
            '  the dimesnoins of the source      ',...
            '  volume. For this editor the       ',...
            '  selected volume applied as a mask ',...
            '  over the original source volume.',...
            '',...
            '--Set Selection sets the masked     ',...
            '  section of the source volume to be',...
            '  used by other portions of the     ',...
            '  editor',...
            '',...
            '--(+) adds a new point in the value ',...
            '  to CAV space mapping. It requires ',...
            '  at least two points before it will',...
            '  update preview of the map on the  ',...
            '  Color Map Button.',...
            '',...
            '--Apply & Refresh will create the   ',...
            '  CAV representation based on the   ',...
            '  selected volume and map settings  ',...
            '  , and it updates the Layer editor ',...
            '  with this representation.',...
            '',...
            };


end

function [text] = getAboutVolumetric()
    
    text = {'<= Back to Topic List',...
            '',...
            '',...
            'VOLUMETRIC                          ',...
            '    Volumetric is a tool to help    ',...
            'researchers and others visualize    ',...
            'volumetric data. It offers utilities',...
            'for building and exploring          ',...
            'vizualizations. It also offeres a   ',...
            'few elementry tools for manipulating',...
            'and preparing source data for       ',...
            'constructing visualiations.         ',...
            '    Volumetric is not designed to   ',...
            'perform numerical analysis on the   ',...
            'input data. There are many programs ',...
            'freely available to researchers and ',...
            'for a fee that perform these        ',...
            'functions. Volumetric is best used in',...
            'conjucntion with programs designed  ',...
            'to perform numerical and scientific ',...
            'analysis on volumetric data.        ',...
            '    MRI, Geoscience, and Physics are',...
            'examples of fields that generate    ',...
            'volumetric data that often times    ',...
            'due to lack of better or simple     ',...
            'options are visually inspected and  ',...
            'understood in slice planes. I was   ',...
            'asked to make some software to      ',...
            'allow our lab to make quick and     ',...
            'intuitive visualizations of         ',...
            'contrasts in the brain. I would make',...
            'a visualization technique and within',...
            'days they would want to visualize   ',...
            'something new that would require    ',...
            'writing a new technique to visualize',...
            'it.',...
            '    Eventually I decided to make a  ',...
            'more durable solution that would    ',...
            'enable researchers who wanted to ',...
            'see their data in 3d in a particular',...
            'way - without me having to write    ',...
            'some new peice of in-house code they',...
            'would have to wait for. So I tried  ',...
            'to figure out what the main         ',...
            'components used in 3d visualizations',...
            'were. I settled on filled volumes,  ',...
            'shells around volumes, and clouds.  ',...
            'I figured if I could let the        ',...
            'researchers convert their data into ',...
            'these forms easily and combine      ',...
            'them as they wished, that would go a',...
            'long way. Thats what Volumetric is  ',...
            'supposed to do.',...
            };

end
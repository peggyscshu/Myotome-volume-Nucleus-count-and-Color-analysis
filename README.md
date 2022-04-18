# Myotome-volume-and-color-analysis https://zenodo.org/badge/482789058.svg
The tools in this repository are designed to analyze the confocal images of zebrafish myotome whose membrane is labeled by the multicolor cell barcode(Ref.1). Two types of analysis done by four scripts are included in this repository. The first application is used to process the zebrafish myotome image before 3D volume quantification. Second, the unique color of the multicolor labeling was extracted iteratively from images which constitute a single myotome. At the end, the python tool is used to project the identified color to a 3D plot with gray value RGB as axes to draw the representative result image.
# 3D volume analysis of zebrafish myotome
  Zebrafish myotomes were sagittal sliced by Leica laser scanning microscope TCS-SP8 to get 3D stacks (Fig. 1A). Limited by low signal to noise ratio (sn ratio) of live confocal images, raw images were denoised by Gaussian filter and the membrane labeling was enhanced by anisotropic diffusion in Fiji to get a processed image with better sn ratio (Fig. 1B upper). Because the cytoplasm surrounded by the fluorescence-labeled membrane forms a close space in the XZ-axis view, the 3D stack was transformed 90 to get a dataset resliced in XZ direction by Imaris (Fig. 2.). Each processed XZ section image that is ready for automatically identifying cytoplasm was stored individually in a folder for following batch process. In the batch processing tool “Batch process myofiber volume.ijm”, the myotome region was delineated to define the outermost layer of fish body in order to generate a close space for the myofibers on the top and the bottom planes where cell membranes were less labeled. Then the cytoplasm region was identified by the command “Find Maxima” and been filled with a color value in order to generate a solid cytoplasm image (Fig. 1B). The volume of each myofiber was quantified by Imaris from the solid cytoplasm image by surface rendering (Fig. 1C). After this process, most of the myofibers are recognized as an individual one to get the 3D volume which can’t be measured from the raw image.   
 
# Unique color quantification
  To count the unique color number from the membrane-labeled myofibers, color probes were placed on each membrane segment isolated from a series sagittal section of a myotome. The color values in LAB space were measured from each color probe and compared to each other in order to identify the unique color with a defined color difference dE value. The unique colors were stripped to generate the first extraction result from each XZ slice. Then these stripped colors were secondarily compared to each other to count for the unique color number in a myotome. At the end, the gray values in RGB space were measured from identified unique colors and been projected to a 3D plot to show the distribution of representative colors of a myotome (Fig. 3). 
  All the above works were done with three scripts. The script “Color analysis 1” is a Fiji-based script to extract unique colors within each transverse slice. It denoised and downsized raw images first and then processed them with tubeness and skeleton algorithm to isolate each membrane segment(Ref. 2, 3). Color probes were placed on each isolated segment to measure the LAB color values (Fig. 4). The measured LAB values from each probe were used to set a cross comparing table to calculate the color difference noted as dE. As dE value showed the color difference larger than 37.4, the compared two colors were considered as different colors in this example. All identified unique colors were draw in different rectangles to give the analysis result and the RGB values of them were print to give arrays for further usage (Fig. 5). The second script “Color analysis 2” is used to extract unique colors from the color strips identified earlier in order to converge the result from each XZ slice to a myotome. The last script is compiled with Python to project the identified color to a 3D plot with RGB gray values as three axes.  

# Feedback
1.	Made changes to the layout templates or some other part of the code? Fork this repository, make your changes, and send a pull request.
2.	Do these codes help on your research? Please cite as the follows. Title
# Figures
![image](https://user-images.githubusercontent.com/67047201/163791252-7070a9af-df27-4798-9ed6-13a91de4a93f.png)
![image](https://user-images.githubusercontent.com/67047201/163791408-c7abbceb-7d75-4001-9fa3-2af6baf5509c.png)
![image](https://user-images.githubusercontent.com/67047201/163789182-418c873b-6bbc-4ccc-91c9-ace65335ecd6.png)
![image](https://user-images.githubusercontent.com/67047201/163791046-39e74f21-4dbe-40b1-aa8a-6e5ea1cf8e5f.png)
![image](https://user-images.githubusercontent.com/67047201/163789750-545f230c-0227-45c4-82cb-3e8eddcee769.png)
# Reference
1.	Chen CH, Puliafito A, Cox BD, Primo L, Fang Y, Di Talia S and Poss KD. Multicolor Cell Barcoding Technology for Long-Term Surveillance of Epithelial Regeneration in Zebrafish. Dev Cell. 2016;36:668-80.
2.	Sato Y, Nakajima S, Shiraga N, Atsumi H, Yoshida S, Koller T, Gerig G and Kikinis R. Three-dimensional multi-scale line filter for segmentation and visualization of curvilinear structures in medical images. Med Image Anal. 1998;2:143-68.
3.	Arganda-Carreras I, Fernandez-Gonzalez R, Munoz-Barrutia A and Ortiz-De-Solorzano C. 3D reconstruction of histological sections: Application to mammary gland tissue. Microsc Res Tech. 2010;73:1019-29.


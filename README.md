# Myotome volume, nucleus count and color analysis  [![DOI](https://zenodo.org/badge/482789058.svg)](https://zenodo.org/badge/latestdoi/482789058)
  The tools in this repository are designed to analyze the confocal images of zebrafish myotome whose membrane is labeled by the multicolor cell barcode1. Three types of analysis done by five scripts are included in this repository. The first application is used to process the zebrafish myotome image before 3D volume quantification. Second, a stack image with the center of each nucleus is built. Therefore, the nucleus number can be counted along with myofibers. Third, the unique color of the multicolor labeling was extracted iteratively from images which constitute a single myotome. At the end, the python tool is used to project the identified color to a 3D plot with gray value RGB as axes to draw the representative result image.
# 3D volume analysis and the nucleus count of zebrafish myotome
 Zebrafish myotomes were sagittal sliced by Leica laser scanning microscope TCS-SP8 to get 3D stacks (Fig. 1A). Limited by low signal to noise ratio (sn ratio) of live confocal images, raw images were denoised by Gaussian filter and the membrane labeling was enhanced by anisotropic diffusion in Fiji to get a processed image with better sn ratio (Fig. 1B upper). Because the cytoplasm surrounded by the fluorescence-labeled membrane forms a close space in the XZ-axis view, the 3D stack was transformed 90 to get a dataset resliced in XZ direction by Imaris (Fig. 2.). Each processed XZ section image that is ready for automatically identifying cytoplasm was stored individually in a folder for following batch process. In the batch processing tool “Batch process myofiber volume.ijm”, the myotome region was delineated to define the outermost layer of fish body in order to generate a close space for the myofibers on the top and the bottom planes where cell membranes were less labeled. Then the cytoplasm region was identified by the command “Find Maxima” and been filled with a color value in order to generate a solid cytoplasm image (Fig. 1B). The volume of each myofiber was quantified by Imaris from the solid cytoplasm image by surface rendering (Fig. 1C). After this process, most of the myofibers are recognized as an individual one to get the 3D volume which can’t be measured from the raw image.  
	In order to count the nucleus number in each myofiber, the nucleus image was extracted and analyzed by 3D object counter to get the mass center in the 3D space (Fig. 1D left). For the advanced nucleus counting purpose, the mass center was resized as a one-pixel point and filled with the gray value 1 (Fig. 3). Then the nucleus center image was merged with the myofiber image gotten by “Batch process myofiber volume.ijm” to count the nucleus number in each myofiber (Fig. 1D right). 
 
# Unique color quantification
 To count the unique color number from the membrane-labeled myofibers, color probes were placed on each membrane segment isolated from a series sagittal section of a myotome. The color values in LAB space were measured from each color probe and compared to each other in order to identify the unique color with a defined color difference dE value. The unique colors were stripped to generate the first extraction result from each XZ slice. Then these stripped colors were secondarily compared to each other to count for the unique color number in a myotome. At the end, the gray values in RGB space were measured from identified unique colors and been projected to a 3D plot to show the distribution of representative colors of a myotome (Fig. 4). 
  All the above works were done with three scripts. The script “Color analysis 1” is a Fiji-based script to extract unique colors within each transverse slice. It denoised and downsized raw images first and then processed them with tubeness and skeleton algorithm to isolate each membrane segment2, 3. Color probes were placed on each isolated segment to measure the LAB color values (Fig. 5). The measured LAB values from each probe were used to set a cross comparing table to calculate the color difference noted as dE. As dE value showed the color difference larger than 37.4, the compared two colors were considered as different colors in this example. All identified unique colors were draw in different rectangles to give the analysis result and the RGB values of them were print to give arrays for further usage (Fig. 6). The second script “Color analysis 2” is used to extract unique colors from the color strips identified earlier in order to converge the result from each XZ slice to a myotome. The last script is compiled with Python to project the identified color to a 3D plot with RGB gray values as three axes. 

# Feedback
1.	Made changes to the layout templates or some other part of the code? Fork this repository, make your changes, and send a pull request.
2.	Do these codes help on your research? Please cite as the follows. Title
# Figures
![image](https://user-images.githubusercontent.com/67047201/165477349-f087234a-4ba9-4bf5-b7c3-48acf799e8eb.png)
![image](https://user-images.githubusercontent.com/67047201/165477580-8a5c4426-296a-4475-9d91-0ca2eaec8804.png)
![image](https://user-images.githubusercontent.com/67047201/165477708-8f8b8ed7-d4d9-4c06-8955-06e543c34b17.png)
# Reference
1.	Chen CH, Puliafito A, Cox BD, Primo L, Fang Y, Di Talia S and Poss KD. Multicolor Cell Barcoding Technology for Long-Term Surveillance of Epithelial Regeneration in Zebrafish. Dev Cell. 2016;36:668-80.
2.	Sato Y, Nakajima S, Shiraga N, Atsumi H, Yoshida S, Koller T, Gerig G and Kikinis R. Three-dimensional multi-scale line filter for segmentation and visualization of curvilinear structures in medical images. Med Image Anal. 1998;2:143-68.
3.	Arganda-Carreras I, Fernandez-Gonzalez R, Munoz-Barrutia A and Ortiz-De-Solorzano C. 3D reconstruction of histological sections: Application to mammary gland tissue. Microsc Res Tech. 2010;73:1019-29.


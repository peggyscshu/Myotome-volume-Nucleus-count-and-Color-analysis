/* This script is designed to draw the outline on cell membrane of zebrafish myofibers for further 3D volume analysis.
 * Compiled by Shao-Chun, Peggy, Hsu at 20200218
 * peggyschsu@gmail.com/ peggyschsu@ntu.edu.tw 
*/

//Set Batch
   dir = getDirectory("Choose the rotated image folder");
   diropt = getDirectory("Choose the output image folder");
   setBatchMode(true);
   processFiles(dir);
      
    function processFiles(dir) {
      list = getFileList(dir);
      //print(list.length);
      for (i=0; i<list.length; i++) {
          if (endsWith(list[i], "/")){
          	//print(i +" is " + list[i]);
          	folderName = list[i];
          	folderName = replace(folderName,"/","");
          	//print(folderName);
            subfolderpath = dir + list[i];
            subfolderpath = replace(subfolderpath, "/", ""); 
           	list2 = getFileList(subfolderpath);
           	//fileno=list2.length;
           	//print(i + " is "+ fileno);
           	for(j=0; j<list2.length; j++){
           		open(dir + list[i] +list2[j]);
                File.makeDirectory(diropt + File.separator + folderName);
                makeinside();
                saveAs("Tiff", diropt + File.separator + folderName +File.separator + list2[j]);
                //copy();
            }
          }
          else{
          	open(dir + list[i]);
          	makeinside();
          	saveAs("Tiff", diropt + File.separator + list[i]);
          }
         }
      }

     function copy(){
     	open(dir + list[i] +list2[j]);
        File.makeDirectory(diropt + File.separator + folderName);
     	saveAs("Tiff", diropt + File.separator + folderName +File.separator + list2[j]);
     }
             
      function makeinside(){
			//Preapre folder and image
			    //tifName= getTitle();
			    //selectWindow(tifName);
				rename("Raw");
				run("Duplicate...", "title=1");
			//Get body region
				selectWindow("1");
				setThreshold(22, 255);
				setOption("BlackBackground", true);
				run("Convert to Mask");
				run("Fill Holes");
			    run("Duplicate...", "title=2");
				//Define body outline
					selectWindow("1");
					run("Erode");
					run("Find Edges");
					run("Gaussian Blur...", "sigma=0.8");
			//Get fiber mask	
				imageCalculator("Add create", "Raw","1");
				run("Find Maxima...", "prominence=10 light output=[Segmented Particles]");
			//Get body mask
				selectWindow("2");
				run("Erode");
				run("Divide...", "value=255");
				imageCalculator("Multiply create", "Result of Raw Segmented","2");
				run("Gaussian Blur...", "sigma=1");
			//Clear
				selectWindow("2");
				close();
				selectWindow("Result of Raw Segmented");
				close();
				selectWindow("Result of Raw");
				close();
				selectWindow("1");
				close();
			//Finalize
			run("Merge Channels...", "c1=Raw c2=[Result of Result of Raw Segmented] create");
		}

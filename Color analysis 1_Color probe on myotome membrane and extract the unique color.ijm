/* This is designed to identify unique colors in the tube-like structure.
 *  Compiled by Shao-Chun, Peggy, Hsu.
 *  E-mail peggyschsu@gmail.com
 *  Compile date: 2021/4/18
 */

//Preparation
	tifName = getTitle();
	rename("Raw");
	newImage("Color code", "RGB white", 255, 25, 1);
	run("Set Measurements...", "area mean redirect=None decimal=1");
	selectWindow("Raw");
	run("Median...", "radius=2");
	run("Size...", "width=256 height=256 depth=1 constrain average interpolation=None");
	run("Duplicate...", "title=Raw-1");
	run("8-bit");
//Place sampling probes on the cell membrane
	//Get membrane segments
		selectWindow("Raw-1");
		run("Tubeness", "sigma=1.0000 use");
		run("8-bit");
		setThreshold(24, 255);
		run("Convert to Mask");
		run("Skeletonize");
		run("Analyze Skeleton (2D/3D)", "prune=none display");
		selectWindow("Tagged skeleton");
		setThreshold(126, 255);
		run("Analyze Particles...", "size=3.00-Infinity exclude add");
	//Get single point from each segment
		selectWindow("Raw");
		getDimensions(width, height, channels, slices, frames);
		newImage("UltraPoint", "8-bit black", width, height, 1);
		selectWindow("UltraPoint");
		roiManager("Show All without labels");
		setForegroundColor(255, 255, 255);
		roiManager("Fill");
		setThreshold(129, 255);
		run("Convert to Mask");
		run("Ultimate Points");
		roiManager("Delete");
		selectWindow("UltraPoint");
		setThreshold(1, 1);
		run("Analyze Particles...", "size=0-Infinity exclude add");
	//Clear
		selectWindow("tubeness of Raw-1");
		close();
		selectWindow("tubeness-labeled-skeletons");
		close();
		selectWindow("Raw-1");
		close();
		run("Clear Results");
		selectWindow("Tagged skeleton");
		close();
//Get LAB value
	//Convert RGB to LAB
		selectWindow("Raw");
		run("RGB to CIELAB");
	//Measure L value
		selectWindow("Raw Lab");
		setSlice(1);
		roiManager("Show All");
		roiManager("Measure");
		Table.renameColumn("Mean", "L");
		Table.rename("Results", "Lab value");
	//Measure A value
		setSlice(2);
		roiManager("Measure");
		n = roiManager("count");
		for (i = 0; i < n; i++) {
			selectWindow("Results");
			a = Table.get("Mean", i);
			selectWindow("Lab value");
			Table.set("a", i, a);
		}		
		run("Clear Results");	
	//Measure B value
		setSlice(3);
		roiManager("Measure");
		for (i = 0; i < n; i++) {
			selectWindow("Results");
			b = Table.get("Mean", i);
			selectWindow("Lab value");
			Table.set("b", i, b);
		}	
		run("Clear Results");	
	//Clear
		selectWindow("Raw Lab");
		close();
//Generate a table for cross comparison 
	//Preparation
		Table.deleteColumn("Area");
		n = Table.size();
	//Create ArrayL
		ArrayL = newArray(3);
		ArrayL[0]= "NA";
		ArrayL[1]= "NA";
		ArrayL[2]= "NA";
		for(i=0; i<n; i++){
			L = Table.get("L", i);
			ArrayL = Array.concat(ArrayL,L);
		}
	//Creat ArrayA
		ArrayA = newArray(3);
		ArrayA[0]= "NA";
		ArrayA[1]= "NA";
		ArrayA[2]= "NA";
		for(i=0; i<n; i++){
			A = Table.get("a", i);
			ArrayA = Array.concat(ArrayA,A);
		}
		//Array.print(ArrayA);
	//Create ArrayB
		ArrayB = newArray(3);
		ArrayB[0]= "NA";
		ArrayB[1]= "NA";
		ArrayB[2]= "NA";
		for(i=0; i<n; i++){
			B = Table.get("b", i);
			ArrayB = Array.concat(ArrayB,B);
		}
		//Array.print(ArrayB);
	//Set column
		Table.setColumn("L", ArrayL);
		Table.setColumn("a", ArrayA);
		Table.setColumn("b", ArrayB);
	//Set arrayF which carries LAB values from each probe
		ArrayL = Array.slice(ArrayL,3);
		ArrayA = Array.slice(ArrayA,3);
		ArrayB = Array.slice(ArrayB,3);
		lenL = lengthOf(ArrayL);
		for(i = 0; i < lenL; i ++){
			arrayF = newArray(0);
			arrayF = Array.concat(ArrayL[i],ArrayA[i], ArrayB[i]);
			Table.setColumn("F" + i , arrayF);
		}
//Justify the color difference of testers from the reference fiber, count color number and draw result image
	//Calculate dE
		n = Table.size();
		for(j =3; j<n; j++){
			Fn = j-3;	
			Lref = getResult("F"+Fn, 0);
			Aref = getResult("F"+Fn, 1);
			Bref = getResult("F"+Fn, 2);
			for (i = 3; i < n; i++) {
				Ltester = getResult("L", i);
				Atester = getResult("a", i);
				Btester = getResult("b", i);
				dE = sqrt(pow((Ltester - Lref),2) + pow((Atester - Aref),2) + pow((Btester - Bref),2));
				Table.set("F"+Fn, i, dE);
			}
		}
	//Delete the repeated value
		for(l =1; l<n-3; l++){
			for(k=1; k<n-3; k++){
				Table.set("F"+k, 3, "NA");
				if(k+l<n-3){
					Table.set("F"+k+l, 3+l, "NA");
				}
			}
		}
	//Find dE< 37.4
		//ReorgaRaw
			selectWindow("Raw");
			run("Split Channels");
			run("Merge Channels...", "c1=[Raw (red)] c2=[Raw (green)] c3=[Raw (blue)] create");
			selectWindow("Composite");
			rename("Raw");
			colorN = 0;
			for(q = 0; q<n-3; q++){//Loop in each Fn
				codeArray= newArray(0);//codeArray = identified fiber with uniqe color
				for(m =3; m<n; m++){//Loop in each row
					selectWindow("Lab value");
					dE = parseFloat(Table.get("F" + q, m));
					if(dE<37.4){
						codeArray= Array.concat(codeArray, m-2);// current testing fiber name = m-2 (=q+1)
						//ID the color code as the fiber number starting from 1
						for (p = 0; p < n-3; p++) {
							Table.set("F" + p, m, "Color" + q+1);
						}
					}
			}
			len=lengthOf(codeArray);
			if(len>0){
				Array.print(codeArray);
				for (i = 0; i < 1; i++) {
					//Get RGB from region
						selectWindow("Raw");
						run("Split Channels");
						roiId = codeArray[i]-1;
						selectWindow("C1-Raw");
						roiManager("Select", roiId);
						roiManager("Measure");
						selectWindow("Results");
						R = Table.get("Mean", 0);
						run("Clear Results");
						selectWindow("C2-Raw");
						roiManager("Select", roiId);
						roiManager("Measure");
						selectWindow("Results");
						G = Table.get("Mean", 0);
						run("Clear Results");
						selectWindow("C3-Raw");
						roiManager("Select", roiId);
						roiManager("Measure");
						selectWindow("Results");
						B = Table.get("Mean", 0);
						run("Clear Results");
					//Make color code
						selectWindow("Color code");
						run("Specify...", "width=1 height=25 x=colorN y=0");
						setForegroundColor(R, G, B);
						fill();
						run("Merge Channels...", "c1=C1-Raw c2=C2-Raw c3=C3-Raw create");
				}
			colorN=colorN+1;
			}
		}
		print("Color number (dE<37.4)="+colorN);
	//Clear
		selectWindow("Lab value");	
		run("Close");
		selectWindow("Results"); 
		run("Close");
		selectWindow("UltraPoint");
		run("Close");
		selectWindow("Color code");
		run("Select None");		
		run("Specify...", "width=colorN height=25 x=0 y=0");	
		run("Crop");
showMessage("--Finish--");
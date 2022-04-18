//Measure the canvas size and generate the canvas
	//Calculate the canvas size
		n = 63; //Type image number + 1 here
		WidthCanvas = 0;
		for (i = 1; i < n; i++) {
			selectWindow("Color code_" + i + ".tif");
			getDimensions(width, height, channels, slices, frames);
			WidthCanvas = WidthCanvas + width;
		}
		newImage("All Color", "24-bit black", WidthCanvas, 25, 1);
	//Collect color on the canvas
		pasteSite = 0;
		for (i = 1; i < n; i++) {
		selectWindow("Color code_" + i + ".tif");
		run("Select All");
		run("Copy");
		getDimensions(width, height, channels, slices, frames);
		selectWindow("All Color");
		makeRectangle(pasteSite, 0, width, 25);
		run("Paste");
		pasteSite = pasteSite + width;
		}
		run("Select None");
	//Clear
		for (i = 1; i < n; i++) {
			selectWindow("Color code_" + i + ".tif");
			close();
		}
//Measure LAB
	//Convert RGB to LAB
		selectWindow("All Color");
		run("RGB to CIELAB");
		getDimensions(width, height, channels, slices, frames);
  	//Measure L value
		selectWindow("All Color Lab");
		setSlice(1);
		for (j = 0; j < width; j++) {
			makeRectangle(j, 0, 1, 1);
			run("Measure");
		}
		Table.renameColumn("Mean", "L");
		Table.rename("Results", "Lab value");	
	//Measure A value
		selectWindow("All Color Lab");
		setSlice(2);
		for (j = 0; j < width; j++) {
			makeRectangle(j, 0, 1, 1);
			run("Measure");
		}
		n = nResults;
		for (k = 0; k < n; k++) {
			selectWindow("Results");
			a = Table.get("Mean", k);
			selectWindow("Lab value");
			Table.set("a", k, a);
		}		
		run("Clear Results");	
	//Measure B value
		selectWindow("All Color Lab");
		setSlice(3);
		for (j = 0; j < width; j++) {
			makeRectangle(j, 0, 1, 1);
			run("Measure");
		}
		for (l = 0; l < n; l++) {
			selectWindow("Results");
			b = Table.get("Mean", l);
			selectWindow("Lab value");
			Table.set("b", l, b);
		}	
		run("Clear Results");	
		selectWindow("All Color");
		rename("Raw");
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
		//Array.print(ArrayL);
	//Create ArrayA
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
	//Set arrayF which carries LAB values from each fiber
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
		colorN = 0;
		n = Table.size();
		newImage("Converged Color", "24-bit black", WidthCanvas, 25, 1);
		for(q = 0; q<n-3; q++){//Loop in each Fn
			codeArray= newArray(0);//codeArray = identified fiber with uniqe color
			for(m =3; m<n; m++){//Loop in each row
				selectWindow("Lab value");
				dE = parseFloat(Table.get("F" + q, m));
				if(dE<37.4){
					codeArray= Array.concat(codeArray, m-2);// current testing fiber name = m-2 (= q+1)
					//ID the color code as the fiber number starting from 1
						for (p = 0; p < n-3; p++) {
							Table.set("F" + p, m, "Color" + q+1);
						}
				}
			}
			len=lengthOf(codeArray);
			if(len>0){
				Array.print(codeArray);
				colorN=colorN+1;
		//Draw the converged color code
				selectWindow("Raw");
				c1 = codeArray[0];
				cindx= c1-1;
				makeRectangle(cindx, 0, 1, 25);
				run("Copy");
				selectWindow("Converged Color");
				makeRectangle(colorN-1, 0, 1, 25);
				run("Paste");
			}
		}
		print("Color number (dE<37.4)="+colorN);
	//Clear
		selectWindow("Results"); 
		run("Close");
		selectWindow("All Color Lab");
		run("Close");
		selectWindow("Raw");
		close();
		selectWindow("Converged Color");
		makeRectangle(0, 0, colorN, 25);
		run("Crop");
//Draw analysis result in a sorted color from hue
	//Measure hue value from the unique color
		selectWindow("Converged Color");
		getDimensions(width, height, channels, slices, frames);
		run("Duplicate...", " ");
		selectWindow("Converged Color-1");
		run("HSB Stack");
		hue = newArray(0);
		for (i = 0; i < width; i++) {
			makeRectangle(i, 0, 1, 1);
			getStatistics(area, mean, min, max, std, histogram);
			hue = Array.concat(hue,mean);
		}
	//Sort color by hue and get index
		sortedValues = Array.copy(hue);
		Array.sort(sortedValues);
		rankPosArr = Array.rankPositions(hue);
		ranks = Array.rankPositions(rankPosArr);
	//Generate representative data
		newImage("Sorted Color", "RGB black", width, height, 1);
		len = lengthOf(rankPosArr);
		for (j = 0; j < len; j++) {
			selectWindow("Converged Color");
			makeRectangle(rankPosArr[j], 0, 1, 25);
			run("Copy");
			selectWindow("Sorted Color");
			makeRectangle(j, 0, 1, 25);
			run("Paste");
		}
	//Clear
		selectWindow("Sorted Color");
		run("Select None");
		selectWindow("Converged Color");
		close();
		selectWindow("Converged Color-1");
		close();
//Get RGB color from the sorted color
	//Measure RGB from analyzed result
		selectWindow("Sorted Color");
		run("RGB Stack");
		ArrayR = newArray(0);
		setSlice(1);
		for (j = 0; j < len; j++) {
			makeRectangle(j, 0, 1, 1);
			getStatistics(area, mean, min, max, std, histogram);
			ArrayR = Array.concat(ArrayR,mean);
		}
		ArrayG = newArray(0);
		setSlice(2);
		for (j = 0; j < len; j++) {
			makeRectangle(j, 0, 1, 1);
			getStatistics(area, mean, min, max, std, histogram);
			ArrayG = Array.concat(ArrayG,mean);
		}
		ArrayB = newArray(0);
		setSlice(3);
		for (j = 0; j < len; j++) {
			makeRectangle(j, 0, 1, 1);
			getStatistics(area, mean, min, max, std, histogram);
			ArrayB = Array.concat(ArrayB,mean);
		}
	//Print RGB value and recover the result image
		print("ArrayR = "); 
		Array.print(ArrayR);
		print("ArrayG = "); 
		Array.print(ArrayG);
		print("ArrayB = "); 
		Array.print(ArrayB);
		selectWindow("Sorted Color");
		run("Select None");
		run("RGB Color");
		//run("Size...", "width=100 height=50 depth=1 average interpolation=Bilinear");
showMessage("--Finish--");
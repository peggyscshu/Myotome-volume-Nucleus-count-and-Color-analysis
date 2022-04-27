// Prepare
	tifName = getTitle();
	run("Split Channels");
	selectWindow("C2-" + tifName);
	close();
	selectWindow("C1-" + tifName);
	run("Threshold...");
	setThreshold(26, 255);
	waitForUser("Adjust the thrshold for nucleus");
	run("Convert to Mask", "method=Default background=Dark black");
//Get the center of each nucleus
	run("3D OC Options", "  dots_size=5 font_size=10 redirect_to=none");
	run("3D Objects Counter", "threshold=128 slice=66 min.=10 max.=40441576 exclude_objects_on_edges centres_of_masses");
	selectWindow("C1-" + tifName);
	close();
	selectWindow("Centres of mass map of C1-" + tifName);
	getDimensions(width, height, channels, slices, frames);
	for (i = 1; i < slices+1; i++) {
		selectWindow("Centres of mass map of C1-" + tifName);
		setSlice(i);
		run("Find Maxima...", "prominence=10 output=[Single Points]");
	}
	selectWindow("Centres of mass map of C1-" + tifName);
	close();
//Reconstruct 2D image as 3D stack
	run("Concatenate...", "all_open open");
	run("Divide...", "value=255 stack");
	run("Re-order Hyperstack ...", "channels=[Channels (c)] slices=[Frames (t)] frames=[Slices (z)]");
	run("Invert LUT");

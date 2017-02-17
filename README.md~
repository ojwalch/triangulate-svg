# triangulate-svg
Quick and dirty triangulation -> SVG in Matlab

This script takes an image and 
- find corners using Matlab's `corner` function
- adds some number (`numRand`) of random points to the list of corners
- gets a Delaunay triangulation of these points
- fills them in with the color at the centroid of the triangle
- plots the output in Matlab, and
- saves an SVG file with the triangulated image 


To use the method call

`triangulate('your-filename-here.png',p)` 

where `p` is the "maximum number of corners" parameter passed to Matlab's `corner` function 


Examples: 
`triangulate('emmy.png',600)` 

![Emmy Noether](https://github.com/ojwalch/triangulate-svg/blob/master/emmy_output.png "Emmy Noether")


`triangulate('astro.png',200)` 
![Space](https://github.com/ojwalch/triangulate-svg/blob/master/astro_output.png "Space")

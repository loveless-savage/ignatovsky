# TODO
1. show mirror fields
2. double lineout

# high-level structure
* `main` -- overall control
  * `rot` -- given an array of field vectors, express each in a rotated basis
  * `mirror` -- generate a grid of points on the mirror, offset to rotated centerpoint
  * `pvec` -- mirror fields given coordinates on the parabola
  * `IgnatovskyIntegral` -- given probe points, find field vectors at those points based on mirror vectors
  * `Singh` -- generate Singh-model fields
  * `Soap` -- generate fields according to updated model, which can handle off-axis factors
  * `FieldCrossMovie` -- given area of interest, render a sweeping cross-section scan through electromagnetic fields
    * `FieldCrossRender` -- given a single slicing plane, render fields
    * `PhaseColor` -- colormap for complex phase


# TODO
1. mimic cylindrical integral
2. shift incoming envelope off-axis
3. describe alignment angles / directions
4. overlay skewed Singh model

# high-level structure
* `main` -- overall control
  * `IgnatovskyIntegral` -- given probe points, find field vectors at those points based on mirror vectors
  * `RotateVecs` -- given an array of field vectors, express each in a rotated basis
  * `FieldCrossMovie` -- given area of interest, render a sweeping cross-section scan through electromagnetic fields
    * `FieldCrossRender` -- given a single slicing plane, render fields
    * `PhaseColor` -- colormap for complex phase
  * `Singh` -- generate Singh-model fields

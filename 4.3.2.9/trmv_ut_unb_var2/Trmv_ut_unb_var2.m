function [ x_out ] = Trmv_ut_unb_var2( U, x )
% Computes x := U'x using AXPY without explicitly transposing U
% where U is an upper triangular matrix and overwriting x within the function.
% Overwriting of x within the function makes the function use less memory.

  [ UTL, UTR, ...
    UBL, UBR ] = FLA_Part_2x2( U, ...
                               0, 0, 'FLA_BR' );

  [ xT, ...
    xB ] = FLA_Part_2x1( x, ...
                         0, 'FLA_BOTTOM' );

  while ( size( UBR, 1 ) < size( U, 1 ) )

    [ U00,  u01,       U02,  ...
      u10t, upsilon11, u12t, ...
      U20,  u21,       U22 ] = FLA_Repart_2x2_to_3x3( UTL, UTR, ...
                                                      UBL, UBR, ...
                                                      1, 1, 'FLA_TL' );

    [ x0, ...
      chi1, ...
      x2 ] = FLA_Repart_2x1_to_3x1( xT, ...
                                    xB, ...
                                    1, 'FLA_TOP' );

    %------------------------------------------------------------%

    x2 = laff_axpy(chi1, u12t, x2); % u12 in the algorithm but OK for laff_dots()
    chi1 = laff_axpy(chi1, upsilon11, 0); 

    %------------------------------------------------------------%

    [ UTL, UTR, ...
      UBL, UBR ] = FLA_Cont_with_3x3_to_2x2( U00,  u01,       U02,  ...
                                             u10t, upsilon11, u12t, ...
                                             U20,  u21,       U22, ...
                                             'FLA_BR' );

    [ xT, ...
      xB ] = FLA_Cont_with_3x1_to_2x1( x0, ...
                                       chi1, ...
                                       x2, ...
                                       'FLA_BOTTOM' );

  end

  x_out = [ xT
            xB ];

return

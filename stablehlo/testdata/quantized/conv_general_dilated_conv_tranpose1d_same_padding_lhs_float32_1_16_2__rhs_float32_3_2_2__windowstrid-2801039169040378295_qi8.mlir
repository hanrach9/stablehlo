// RUN: stablehlo-translate --interpret -split-input-file %s

module attributes {jax.uses_shape_polymorphism = true} {
  func.func @main() -> tensor<i1> {
    %cst = stablehlo.constant dense<[[[-1.85980642, -4.23970461], [-4.73045349, -0.530883729], [-4.16903257, 5.02416182], [-5.77677679, -0.975355386], [4.46340561, -2.29194045], [-0.758056521, -4.536098], [5.37831163, 0.168776125], [-3.56675458, 2.80054331], [1.13978767, 5.87573242], [-1.11913872, -5.70136929], [4.13804626, 2.45081449], [-2.25734782, -0.941460669], [4.14359236, -5.18526125], [2.85359073, -2.54740357], [-5.29141903, -0.421686381], [1.24744737, 2.0226624]]]> : tensor<1x16x2xf32>
    %cst_0 = stablehlo.constant dense<[[[-5.78321695, -6.70092058], [-4.02411413, -1.5279355]], [[4.82193375, -1.90760541], [4.670856, -1.44685578]], [[-3.33052278, 1.00520051], [1.20746529, -0.450568587]]]> : tensor<3x2x2xf32>
    %cst_1 = stablehlo.constant dense<[[[0.000000e+00, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.000000e+00, 0.000000e+00], [1.00234711, 0.000000e+00], [1.00234711, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.000000e+00, 1.00234711], [1.00234711, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.165222049, 1.00234711], [1.16756916, 0.000000e+00], [1.00234711, 0.000000e+00], [1.00234711, 0.000000e+00], [1.00234711, 1.00234711], [1.9936794, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.000000e+00, 0.000000e+00], [1.00234711, 1.00234711], [1.9936794, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.000000e+00, 1.00234711], [1.00234711, 0.000000e+00], [0.000000e+00, 1.00234711], [1.00234711, 0.000000e+00], [0.000000e+00, 0.000000e+00], [0.000000e+00, 0.000000e+00], [1.00234711, 1.00234711], [1.9936794, 0.000000e+00]]]> : tensor<1x32x2xf32>
    %0 = stablehlo.uniform_quantize %cst_0 : (tensor<3x2x2xf32>) -> tensor<3x2x2x!quant.uniform<i8:f32, 0.0039189298947652183:-128>>
    %1 = stablehlo.uniform_quantize %cst : (tensor<1x16x2xf32>) -> tensor<1x16x2x!quant.uniform<i8:f32, 0.0039215482917486456:-128>>
    %2 = stablehlo.convolution(%1, %0) dim_numbers = [b, 0, f]x[0, i, o]->[b, 0, f], window = {pad = [[2, 1]], lhs_dilate = [2]} {batch_group_count = 1 : i64, feature_group_count = 1 : i64} : (tensor<1x16x2x!quant.uniform<i8:f32, 0.0039215482917486456:-128>>, tensor<3x2x2x!quant.uniform<i8:f32, 0.0039189298947652183:-128>>) -> tensor<1x32x2x!quant.uniform<i32:f32, 1.536827283429924E-5>>
    %3 = stablehlo.uniform_quantize %2 : (tensor<1x32x2x!quant.uniform<i32:f32, 1.536827283429924E-5>>) -> tensor<1x32x2x!quant.uniform<i8:f32, 0.011014803718118107:-128>>
    %4 = stablehlo.uniform_dequantize %3 : (tensor<1x32x2x!quant.uniform<i8:f32, 0.011014803718118107:-128>>) -> tensor<1x32x2xf32>
    %5 = stablehlo.custom_call @check.eq(%cst_1, %4) : (tensor<1x32x2xf32>, tensor<1x32x2xf32>) -> tensor<i1>
    return %5 : tensor<i1>
  }
}
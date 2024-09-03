// RUN: stablehlo-opt --chlo-pre-serialization-pipeline -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s | stablehlo-translate --serialize --target=current | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<5x2xi1> {jax.result_info = "[0]", mhlo.layout_mode = "default"}, tensor<5x2xi32> {jax.result_info = "[1]", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<5x3xi1>
    %1:2 = call @expected() : () -> (tensor<5x2xi1>, tensor<5x2xi32>)
    %values, %indices = chlo.top_k(%0, k = 2) : tensor<5x3xi1> -> (tensor<5x2xi1>, tensor<5x2xi32>)
    stablehlo.custom_call @check.expect_eq(%values, %1#0) {has_side_effect = true} : (tensor<5x2xi1>, tensor<5x2xi1>) -> ()
    stablehlo.custom_call @check.expect_eq(%indices, %1#1) {has_side_effect = true} : (tensor<5x2xi32>, tensor<5x2xi32>) -> ()
    return %values, %indices : tensor<5x2xi1>, tensor<5x2xi32>
  }
  func.func private @inputs() -> (tensor<5x3xi1> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<true> : tensor<5x3xi1>
    return %c : tensor<5x3xi1>
  }
  func.func private @expected() -> (tensor<5x2xi1> {mhlo.layout_mode = "default"}, tensor<5x2xi32> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<true> : tensor<5x2xi1>
    %c_0 = stablehlo.constant dense<[[0, 1], [0, 1], [0, 1], [0, 1], [0, 1]]> : tensor<5x2xi32>
    return %c, %c_0 : tensor<5x2xi1>, tensor<5x2xi32>
  }
}
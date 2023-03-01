// RUN: diff <(stablehlo-opt %s --stablehlo-legalize-to-vhlo --vhlo-to-version=target=current -emit-bytecode | stablehlo-opt --vhlo-legalize-to-stablehlo) <(stablehlo-opt %s)

module @jit_fun_flat_jax {
  func.func public @main(%arg0: tensor<i64>, %arg1: tensor<3x?xf32> {mhlo.sharding = ""}, %arg2: tensor<?x5xf32> {mhlo.sharding = ""}) -> tensor<3x5xf32> {
    %0 = stablehlo.concatenate %arg1, %arg1, dim = 1 : (tensor<3x?xf32>, tensor<3x?xf32>) -> tensor<3x?xf32>
    %1 = stablehlo.concatenate %arg2, %arg2, dim = 0 : (tensor<?x5xf32>, tensor<?x5xf32>) -> tensor<?x5xf32>
    %2 = call @_einsum(%arg0, %0, %1) : (tensor<i64>, tensor<3x?xf32>, tensor<?x5xf32>) -> tensor<3x5xf32>
    return %2 : tensor<3x5xf32>
  }
  func.func private @_einsum(%arg0: tensor<i64>, %arg1: tensor<3x?xf32>, %arg2: tensor<?x5xf32>) -> tensor<3x5xf32> {
    %0 = "stablehlo.dot_general"(%arg1, %arg2) {dot_dimension_numbers = #stablehlo.dot<lhs_contracting_dimensions = [1], rhs_contracting_dimensions = [0]>} : (tensor<3x?xf32>, tensor<?x5xf32>) -> tensor<3x5xf32>
    return %0 : tensor<3x5xf32>
  }
}

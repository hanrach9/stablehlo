// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<8x9xcomplex<f64>> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<8x9xcomplex<f64>>
    %1 = call @expected() : () -> tensor<8x9xcomplex<f64>>
    %2 = call @cumprod(%0) : (tensor<8x9xcomplex<f64>>) -> tensor<8x9xcomplex<f64>>
    stablehlo.custom_call @check.expect_almost_eq(%2, %1) {has_side_effect = true} : (tensor<8x9xcomplex<f64>>, tensor<8x9xcomplex<f64>>) -> ()
    return %2 : tensor<8x9xcomplex<f64>>
  }
  func.func private @inputs() -> (tensor<8x9xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[(0.50974271544424821,2.0367778400310539), (0.22554582033667511,-3.3260904447993247), (-1.8467518226516377,5.8967452494268473), (-5.6199483359164848,-3.2671568876940436), (-1.2598272495132226,-0.16190572439515155), (-0.9490124366222974,3.515546673294669), (-0.56757286464259704,1.1834952656032525), (2.8351085002483867,-5.2724877160490511), (-8.7069117680378145,-1.1153238593347168)], [(0.21812588500852367,0.31678610756820835), (3.4133690773663909,3.5934120374224605), (4.03028180921984,3.2640378357170516), (-1.0600566685733241,-1.7414002466849985), (5.8268710563162784,-2.3834336600043518), (0.97645468478761877,-2.6255571585429966), (7.6278797526346747,2.2163290747128412), (2.2199777351647842,1.5611785205027311), (1.4715292929082544,2.8101165864819846)], [(2.0172096907818888,-4.3222380615637599), (2.5273005623913094,-4.3658224316225667), (2.5087249521559474,-2.361735316795337), (2.7210280612980777,-0.70397010339878807), (-0.12043906816372781,-2.2821689033589454), (-2.6252211773567256,-3.5600781056668525), (0.1408390203087955,2.2520085100112621), (-1.9794089947510916,2.6136988388542726), (4.9137148072372501,5.2519088195712929)], [(2.0419057193319334,-4.8743923341358908), (-3.9014157787140666,-1.2977813085180119), (-0.041752333459731665,-2.0377461343962144), (-4.8597350095162613,3.2523035441278361), (-4.9546471847900886,-6.7583847075453285), (-1.3928910141251909,0.29451534728117246), (2.5721498254959867,-0.99876968629417772), (2.2309831946936201,2.5615455208767512), (-6.1552023134598244,-1.8584607329973055)], [(-3.2330797891302638,-0.77313180673115323), (3.0311878956439564,-1.770425455644232), (-0.24790225623073917,1.5177044141927949), (-5.8491915658486917,4.5467877900332159), (-1.1605212505258009,-4.0157332877304519), (1.4109660644214763,3.5078305420626119), (-3.4457198391178707,-1.3473022775690822), (0.25035726455482682,-1.0780338828668568), (0.2011657038903048,-0.31398566465486399)], [(-3.0532057862726321,-1.2728876282862054), (-0.40910333034572621,0.52064861386858707), (2.0940034078431466,0.57960780557058689), (0.48710416123873657,2.9220093635717883), (0.41598737206700265,-1.446618484688706), (0.11058750720509808,-0.33000658152505746), (1.4180779590880195,0.76317723341938359), (0.12859864963867818,-1.5375110551298095), (-1.3926485243659714,0.42402427255883063)], [(0.45891866482905253,0.35174529202230942), (-2.1071370985278115,-6.2328027582137757), (-1.3133531762329778,0.68636802089167648), (-3.4378098180750412,-1.530245349425619), (-7.1491446317302287,1.7414515929963543), (-2.1883274422772665,0.039378326513060308), (3.8370683030756547,0.046631104211056304), (2.3170839239554386,-2.6483019661985487), (1.0267282204361747,1.0675266682115891)], [(2.8484025131121347,1.9956056800040201), (-1.2077599703838442,4.75463152946483), (5.2519460085931966,-0.43083767525572758), (2.539990559741431,-0.84866397402989224), (2.9241766732674876,-1.449125493981672), (-2.0489177843475561,-5.3223542622745388), (0.062191929644814806,2.5623669620788041), (5.4510095936048213,3.3175172383290725), (0.076464070324578998,-3.5530719858673638)]]> : tensor<8x9xcomplex<f64>>
    return %cst : tensor<8x9xcomplex<f64>>
  }
  func.func private @expected() -> (tensor<8x9xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[(0.50974271544424821,2.0367778400310539), (0.22554582033667511,-3.3260904447993247), (-1.8467518226516377,5.8967452494268473), (-5.6199483359164848,-3.2671568876940436), (-1.2598272495132226,-0.16190572439515155), (-0.9490124366222974,3.515546673294669), (-0.56757286464259704,1.1834952656032525), (2.8351085002483867,-5.2724877160490511), (-8.7069117680378145,-1.1153238593347168)], [(-0.5340348429916959,0.60575337960935516), (12.721884570564162,-10.542695207013708), (-26.690129878690492,17.737677290054158), (0.26803590033682601,13.249950864597251), (-7.7267424894179344,2.0593108929504869), (8.3036010945992799,5.9244584152481128), (-6.9523925292936113,7.7696313319086023), (14.525172319238123,-7.2786948446762247), (-9.6782856410196576,-26.108668906488766)], [(1.5409500527704021,3.5301573121518057), (-13.875509194676038,-82.186048556487947), (-25.066495909114316,107.53397595520653), (10.056902486431186,35.864798852915143), (5.6302969476065217,17.385709948605523), (-0.70725474980597192,-45.114482151152814), (-18.476444031736207,-14.562579875961406), (-9.7269404751046852,52.371940070551425), (89.564013034305176,-179.12002671946999)], [(20.353846466603251,-0.30294671868612655), (-52.525387127762585,338.64932310746286), (220.17352851484191,46.589360719323672), (-165.51709351936864,-141.58531899520219), (89.603181325483376,-124.19177164207845), (14.272036163859125,62.631259416996699), (-62.068845626364528,-19.003425077316393), (-155.85374924309036,91.924917365062441), (-884.17215638306425,936.06880153675218)], [(-66.039827386196478,-14.756755179286023), (440.33906449045395,1119.5020115099194), (-125.29039289925024,322.60872847671061), (1611.8995870726235,75.588553859081941), (-602.7074274882533,-215.69528780421163), (-199.56248597338632,138.43446596236751), (188.26849487762695,149.10597587858385), (60.07905726815919,191.02969331183166), (116.04707061419136,465.92232154215554)], [(182.84949199861936,129.11668955405074), (-763.01134828010072,-228.73007767830231), (-449.34504687134029,602.92448714276532), (564.29253420698819,4746.8051856904822), (-562.74746928392494,782.16118952277532), (23.615167022038683,81.166056298766662), (153.1851168193235,355.12612702246838), (301.43635096124831,-67.806054130779302), (-359.17515510868139,-599.65925886508478)], [(38.496857060533472,123.57050673647754), (182.14005951895109,5237.6648683337226), (176.32065754572213,-1100.2688607361495), (5323.846145669042,-17182.119498042099), (2661.0671995765833,-6571.7809460636372), (-54.873901514998636,-176.68798262235836), (571.22183281311402,1369.7863967379169), (518.88241643338995,-955.40679890767058), (271.37698284885136,-999.11614036017534)], [(-136.94346072614744,428.80308854702605), (-25123.147996640095,-5459.8330964918323), (451.9892955139527,-5854.5182337191636), (-1059.3268639497353,-48160.577748483316), (-1741.9046788047247,-23073.26886440787), (-827.96392469218165,654.07749349142819), (-3474.370020068312,1548.8696116327744), (5998.0115549242555,-3486.5302654573688), (-3529.1809802406374,-1040.6184421883843)]]> : tensor<8x9xcomplex<f64>>
    return %cst : tensor<8x9xcomplex<f64>>
  }
  func.func private @cumprod(%arg0: tensor<8x9xcomplex<f64>>) -> tensor<8x9xcomplex<f64>> {
    %cst = stablehlo.constant dense<(1.000000e+00,0.000000e+00)> : tensor<complex<f64>>
    %0 = "stablehlo.reduce_window"(%arg0, %cst) <{padding = dense<[[7, 0], [0, 0]]> : tensor<2x2xi64>, window_dimensions = array<i64: 8, 1>}> ({
    ^bb0(%arg1: tensor<complex<f64>>, %arg2: tensor<complex<f64>>):
      %1 = stablehlo.multiply %arg1, %arg2 : tensor<complex<f64>>
      stablehlo.return %1 : tensor<complex<f64>>
    }) : (tensor<8x9xcomplex<f64>>, tensor<complex<f64>>) -> tensor<8x9xcomplex<f64>>
    return %0 : tensor<8x9xcomplex<f64>>
  }
}
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s | stablehlo-translate --serialize --target=current | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xbf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xbf16>
    %1 = call @expected() : () -> tensor<20x20xbf16>
    %2 = chlo.tan %0 : tensor<20x20xbf16> -> tensor<20x20xbf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xbf16>, tensor<20x20xbf16>) -> ()
    return %2 : tensor<20x20xbf16>
  }
  func.func private @inputs() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x09C03140F640F63E50BFA53DD83F6A400A3CD43F0AC0DFBF3140B1BF204032C01E40FB3F1BBF9240B43F43404840ACBEE33E9D3F783E09BFB84076BF2140EE3FBF401EC0FCBE8140EBBF143FDF3EB33F133F84BFC7C04E407D40573F23BFA240AFC0ABBF1C408040ECBFEDBF344098C013405840164094BF9E3FA64027BEC7C02740AF40BCBF013F63C0FF3EFEBE09BF02C09340E5BF59C079BFFD3F7BBF1641AEC09BBF95C0AD40B9BD3EC020408A40993EA1C090C0AC3FC7C052C0873D67C0C6BF09C08E403FBF664073405CC013BF15C00640A240B13F63C06DBCD7BF8BBF1D40DB3E96BF36BFF23FA3C009C0DDBF57BF50BDD9BE56409CBD0B3F853FD63F0B3F8AC071BFB1C033C091C0C0BF2740D1404E40EDBFAD400EC082400CBF8C3FA54036400BC01740933F753EEB3F62BE97C098BF583FE83FEE3F1EBFCE3F31C02A40AE40D43ED9BF6140B93F5F40463F5440F63D32BF14C0163F4F40A2C003C013C0C04016C03BC02DC0A740F6BFAE4024C01B4034BF9F3F42C0263F594074BE494099C0D53E4140CD3F9540A93D55402B4062C05A3F9F3F023EA1BFB54005C04DC0983FC5BF7BBFBB3FF03E2DC067C0A53E05C1E1BFC23F9940BB3FB4C09940C3404940E63E18C0C73E5540CA3E63404A40B24032409E4045C0193F0FC0A3401F40E53E53C0C63F6AC002BEC63F88C02A3F8AC0293ED33FF93F9DBF33BF9FBF083FBAC02DC092409CBF23C01D4096402240163F4140D6BD6DC00C3E1340F7BF3D3F3340A4BF923FC0BFCE3F03BF734042BF21BF80C0D93D7FBF1AC0A2C0E3BF8C4038C068C01540C43D2F40BBBF04401240BFBFD6BFA5BFCE3FE93FEE3FAFC047C0ED3F6EC087C0A8BFAF409D3EBE3F80BF47C099BF21C02DC04BC06640D43FF4BF2FBF27C0B7BFD8BD374070BDD43F4CBF8DC03B40D6BFE7BE94C00B3ECF4020C08EBE03C18B3F86BFBEBE2EBF56406D405CBF21405C40173F66C0A53F47BF96C0E23FB1BF393FFA3F81BDFBBFA13EFC3FFE3E05BF2540733F60C0903F463FFDBEAB3BB7C056C0113CC6BF0E40A63F5240233F36C08ABF06C182C020C004C0EB3F7E3B36BFCABE8EC03CC03E408140813F123FB0BFA63F843D2AC01240D23F"> : tensor<20x20xbf16>
    return %cst : tensor<20x20xbf16>
  }
  func.func private @expected() -> (tensor<20x20xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xC83FCABEBE40053F87BFA53D08C1113F0A3C3BC1C13FB940CABEA8C03FBFC13E4CBF1CC031BFD440C140C3BD88BCB3BEF33E33407D3E18BF17BFB7BF39BF58C0A7BE4C3F09BF9E3F6C40273FEE3EB840263FD6BF843D9E3D873F8F3F3DBF2FC0883F86C059BF943F65405E40AFBED54190BF733E83BF11C03740F9BF28BE843D17BF88BF1CC10D3FDCBE0B3F0BBF18BF01400641904082BEBCBF15C0BFBF4CBD903F2AC08EC19ABFBABD333E3FBF17409E3E424094C08B40843D10BE873D01BF27C2C83F63406DBFF93E453F9CBE26BF873FDEBF2FC0A840DCBE6DBC1241F3BF53BFE93E18C05CBF41C02040C83FCC408FBF50BDE7BE523E9CBD1A3FDA3F1EC11A3F17C0B0BF6F3FB83EAFC062C117BF823E9E3D5E409ABFA93FA83F1CBFF83F07C09DBEBB3F7EBF0E407A3E6CC066BE1D431FC0903F82C058C036BFCFC1CA3E07BF90BFE13E0041C93EFE40B73E7A3F313EF73D56BF8C3F2A3FBF3D2F40F83F903F95BE833F653EF03EE7BF2F4090BF273F60BF59BF3C40E33D423F823E79BE7EBA6841E23E02BE02C28E41A93D413E02BFD2BE923F3C40033E46C039BFE63F7CBD1F40FCC1BFBF1141023FF03E01BFAB3E0240A940914168C11141463F68C144BE7EBAF73E773FD23E413ED53EDC3E703C61BFC1BE8CC0823D2E3FA43F20C046BFF63E20BE274211BF03BE274200C0483F17C02B3E4EC123C033C057BF3CC0163F023FF03ED4402EC02D3F53BF214233BF2A3F02BED7BD21BF0D3E90BF2B40693FB8BE57C00B4062C1CFC110BF453F72BF3ABF94BFDA3DC6BF683F2F409C4036408C3E06BF87BFC53DDDBE11C1EFBF95BF4BC11E415DC0CFC17BC058C0883F043D5EC027BFEEBF72C088BFA23E3941C7BF043D22C0393FF03EF8BCF93E3BC1384051BF173FE1C0D9BD94BE70BD3BC183BF4AC065BE1E41F8BE37C10C3E403E3F3F92BE3940F33FDEBFC7BE4FBF523E213F94BF39BF9C3E2B3FF9BE5D407CBF21C2A2C0A8C0623F1FC081BD1C40A73E18C00B3F12BF22BFB33FC0BE06407A3F0ABFAB3B223F52BE113C27C2A9BF6440103E3D3F9D3EEEBFDF3FA8BF3F3FEF3F6CC07E3B5CBFD5BE63C0543E33BE9E3FCB3F243FA1C06440843D073F95BF65C1"> : tensor<20x20xbf16>
    return %cst : tensor<20x20xbf16>
  }
}
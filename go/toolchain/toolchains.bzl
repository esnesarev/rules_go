load(
    "//go/private:go_toolchain.bzl",
    "generate_toolchains",
    "go_toolchain",
)
load(
    "//go/private:sdk.bzl",
    "go_download_sdk",
    "go_host_sdk",
)
load(
    "//go/private:nogo.bzl",
    "go_register_nogo",
)
load(
    "//go/platform:list.bzl",
    "GOARCH",
    "GOOS",
    "GOOS_GOARCH",
)
load(
    "@io_bazel_rules_go//go/private:skylib/lib/versions.bzl",
    "versions",
)

DEFAULT_VERSION = "1.12.6"

MIN_SUPPORTED_VERSION = "1.10"

SDK_REPOSITORIES = {
    "1.12.6": {
        "darwin_amd64": ("go1.12.6.darwin-amd64.tar.gz", "b12bbac3227e72c2964e638e85d6621996bd3c03e172e752334112c3f757ba6e"),
        "freebsd_386": ("go1.12.6.freebsd-386.tar.gz", "5dcdffc8102ff1f53596b7cf0da83d66b1f3f59180e050cb299499aa731f68ac"),
        "freebsd_amd64": ("go1.12.6.freebsd-amd64.tar.gz", "93a273bf283292142fc505bb18a3996e73009d9451c0c245b72013728da3f0af"),
        "linux_386": ("go1.12.6.linux-386.tar.gz", "7aaf25164a9ab5e1005c15535ed16ee122df50ac192c2d79b7940315c2b74f2c"),
        "linux_amd64": ("go1.12.6.linux-amd64.tar.gz", "dbcf71a3c1ea53b8d54ef1b48c85a39a6c9a935d01fc8291ff2b92028e59913c"),
        "linux_arm64": ("go1.12.6.linux-arm64.tar.gz", "8f4e3909c74b4f3f3956715f32419b28d32a4ad57dbd79f74b7a8a920b21a1a3"),
        "linux_arm": ("go1.12.6.linux-armv6l.tar.gz", "0708fbc125e7b782b44d450f3a3864859419b3691121ad401f1b9f00e488bddb"),
        "linux_ppc64le": ("go1.12.6.linux-ppc64le.tar.gz", "67eacb68c1e251c1428e588776c5a02e287a508e3d44f940d31d8ff5d57f0eef"),
        "linux_s390x": ("go1.12.6.linux-s390x.tar.gz", "c14baa10b87a38e56f28a176fae8a839e9052b0e691bdc0461677d4bcedea9aa"),
        "windows_386": ("go1.12.6.windows-386.zip", "9d5644ef8e94ad0853e1a86d5465a4600fe5b2cedc946fff80de46135eab2486"),
        "windows_amd64": ("go1.12.6.windows-amd64.zip", "9badf7bbc0ed55f2db967434b033a2cddf2e46dbdc5bb8560d8fde019e8e19d3"),
    },
    "1.12.5": {
        "darwin_amd64": ("go1.12.5.darwin-amd64.tar.gz", "566d0b407f7d4aa5a1315988b562bbe4e9422a93ce2fbf27a664cddcb9a3e617"),
        "freebsd_386": ("go1.12.5.freebsd-386.tar.gz", "b842330ad695bac9ea57d0a9d3aafaaf34921ec85702bccc2067f448e868332b"),
        "freebsd_amd64": ("go1.12.5.freebsd-amd64.tar.gz", "082acae7f5d2c780521f95fd177a08aacaccc0e38042d4ef981f7d7211a27b8a"),
        "linux_386": ("go1.12.5.linux-386.tar.gz", "146605e13bf337ff3aacd941a816c5d97a8fef8b5817e07fcec4540632085980"),
        "linux_amd64": ("go1.12.5.linux-amd64.tar.gz", "aea86e3c73495f205929cfebba0d63f1382c8ac59be081b6351681415f4063cf"),
        "linux_arm64": ("go1.12.5.linux-arm64.tar.gz", "ff09f34935cd189a4912f3f308ec83e4683c309304144eae9cf60ebc552e7cd8"),
        "linux_arm": ("go1.12.5.linux-armv6l.tar.gz", "311f5e76c7cec1ec752474a61d837e474b8e750b8e3eed267911ab57c0e5da9a"),
        "linux_ppc64le": ("go1.12.5.linux-ppc64le.tar.gz", "e88b2a2098bc79ad33912d1d27bc3282a7f3231b6f4672f306465bf46ff784ca"),
        "linux_s390x": ("go1.12.5.linux-s390x.tar.gz", "168d297ec910cb446d1aea878baeb85f1387209f9eb55dde68bddcd4c006dcbb"),
        "windows_386": ("go1.12.5.windows-386.zip", "9b8cfd668c182d39f2039bbb290cd062de438c7cc48ab3f4d9a326fce3538a03"),
        "windows_amd64": ("go1.12.5.windows-amd64.zip", "ccb694279aab39fe0e70629261f13b0307ee40d2d5e1138ed94738023ab04baa"),
    },
    "1.12.4": {
        "darwin_amd64": ("go1.12.4.darwin-amd64.tar.gz", "50af1aa6bf783358d68e125c5a72a1ba41fb83cee8f25b58ce59138896730a49"),
        "freebsd_386": ("go1.12.4.freebsd-386.tar.gz", "8695afc656e75ecf72c6a9c617b0399bf864f4aa2b4017badbf98c5f56494244"),
        "freebsd_amd64": ("go1.12.4.freebsd-amd64.tar.gz", "44f30606b1f2063bf1277f154b82910dbbe6183513aa8271391a320f45595e4b"),
        "linux_386": ("go1.12.4.linux-386.tar.gz", "eba5c51f657c1b05d5930475d1723758cd86db74499125ab48f0f9d1863845f7"),
        "linux_amd64": ("go1.12.4.linux-amd64.tar.gz", "d7d1f1f88ddfe55840712dc1747f37a790cbcaa448f6c9cf51bbe10aa65442f5"),
        "linux_arm64": ("go1.12.4.linux-arm64.tar.gz", "b7d7b4319b2d86a2ed20cef3b47aa23f0c97612b469178deecd021610f6917df"),
        "linux_arm": ("go1.12.4.linux-armv6l.tar.gz", "c43457b6d89016e9b79b92823003fd7858fb02aea22b335cfd204e0b5be71d92"),
        "linux_ppc64le": ("go1.12.4.linux-ppc64le.tar.gz", "51642f3cd6ef9af6c4a092c2929e4fb478f102fe949921bd77ecd6905952c216"),
        "linux_s390x": ("go1.12.4.linux-s390x.tar.gz", "0aab0f368c090da71f52531ebac977cc7396b692145acee557b3f9500b42467a"),
        "windows_386": ("go1.12.4.windows-386.zip", "4bc649c74c63aec9829523843669794b41e46f99bc78dd3a52f312604d36b165"),
        "windows_amd64": ("go1.12.4.windows-amd64.zip", "25b043ebacca2fa2c87bbcd7463be5f34fbd225247c101888f81647fadbdfca0"),
    },
    "1.12.3": {
        "darwin_amd64": ("go1.12.3.darwin-amd64.tar.gz", "edb7aad4607509e3eb9f8bd3b43fb9c419b4a007874a9f6e2f99c541411f9304"),
        "freebsd_386": ("go1.12.3.freebsd-386.tar.gz", "a8f01edb1d18469b49b45302560f60afdf0bc56794a20a50b87d902d0a4e3d47"),
        "freebsd_amd64": ("go1.12.3.freebsd-amd64.tar.gz", "eee2439553351ae323152529c72fe831b892821dde6e1f4145526ca6aed63349"),
        "linux_386": ("go1.12.3.linux-386.tar.gz", "67599ae0788ed88260531d4be4293cb8f5199e5c7e06d30c6bd95eb54f014be7"),
        "linux_amd64": ("go1.12.3.linux-amd64.tar.gz", "3924819eed16e55114f02d25d03e77c916ec40b7fd15c8acb5838b63135b03df"),
        "linux_arm64": ("go1.12.3.linux-arm64.tar.gz", "4deb7f3b90d03f71f5cac3654e0e1f9cb46c45b85c5475510222b958e4ea2ed6"),
        "linux_arm": ("go1.12.3.linux-armv6l.tar.gz", "efce59fac5ebc7302263ca1093fe2c3252c1b936f5b1ae08afc328eea0403c79"),
        "linux_ppc64le": ("go1.12.3.linux-ppc64le.tar.gz", "8bd04e742be8ed3f7f6fd2c78e2303be2ee70709cdc28758f101765a5e7d6dc1"),
        "linux_s390x": ("go1.12.3.linux-s390x.tar.gz", "102fe607818ba21b9853ddfa3b1225b2af802010af3a032c6487144fbb7f3521"),
        "windows_386": ("go1.12.3.windows-386.zip", "de3446df6f764030c5945800134c191f092dc14d2301f12fee6c8f611ac18829"),
        "windows_amd64": ("go1.12.3.windows-amd64.zip", "1806e089e85b84f192d782a7f70f90a32e0eccfd181405857e612f806ec04059"),
    },
    "1.12.2": {
        "darwin_amd64": ("go1.12.2.darwin-amd64.tar.gz", "82f1c27fefeefb1dc42ed34cab32c2d826e111ade3418066e7049ba8046713f9"),
        "freebsd_386": ("go1.12.2.freebsd-386.tar.gz", "8b642520509242472d48c8ab8ed7518410965c180e253691835a1faf2d8aa44f"),
        "freebsd_amd64": ("go1.12.2.freebsd-amd64.tar.gz", "de534316c754819225549ad99fd52c56fe138f87d909c8fc109bba04db1c1400"),
        "linux_386": ("go1.12.2.linux-386.tar.gz", "3005a7937ff2be7ea9badd416cc37dfe2ff589d3a311f1685de0a805e45455b6"),
        "linux_amd64": ("go1.12.2.linux-amd64.tar.gz", "f28c1fde8f293cc5c83ae8de76373cf76ae9306909564f54e0edcf140ce8fe3f"),
        "linux_arm64": ("go1.12.2.linux-arm64.tar.gz", "598558fe54bbdce8b676f81e37f514dd70b8fc1377086658ae6e836480e900eb"),
        "linux_arm": ("go1.12.2.linux-armv6l.tar.gz", "38d92116cd8c408e995972ff7fb0b6453c4f2214bde602d1772bd88f9d4d5c60"),
        "linux_ppc64le": ("go1.12.2.linux-ppc64le.tar.gz", "62be1d5f38e322edc21de0debd3051247faff59890c343a7f2173c15098dbd35"),
        "linux_s390x": ("go1.12.2.linux-s390x.tar.gz", "a41b0b11f5e34c3cccd7619bddf79a6d4b94bcbd2160fefcdf25f0afe87cad0a"),
        "windows_386": ("go1.12.2.windows-386.zip", "12d61e2b448709c6c3cc6b1bdff87f0f5a54ed0a515a130f9cee4384cde3c993"),
        "windows_amd64": ("go1.12.2.windows-amd64.zip", "4197135ef2221c9d7772063e1bdcd3f51de37811b19a678db87d7fc735a218f9"),
    },
    "1.12.1": {
        "darwin_amd64": ("go1.12.1.darwin-amd64.tar.gz", "1a3d311d77bc685a23f6243a1cb8c52538c4f976239c27dda2d2820225eb8fc9"),
        "freebsd_386": ("go1.12.1.freebsd-386.tar.gz", "392724db9f1cf38630a5ae7ee5c67f1416e8715500298cf81eb777fc4e6858c1"),
        "freebsd_amd64": ("go1.12.1.freebsd-amd64.tar.gz", "aecf1590f5ddbecc506d9e3941df95ecca71e779b1d52b0be82f7f0c14ba2abe"),
        "linux_386": ("go1.12.1.linux-386.tar.gz", "af74b6572dd0c133e5de121928616eab60a6252c66f6d9b15007c82207416a2c"),
        "linux_amd64": ("go1.12.1.linux-amd64.tar.gz", "2a3fdabf665496a0db5f41ec6af7a9b15a49fbe71a85a50ca38b1f13a103aeec"),
        "linux_arm64": ("go1.12.1.linux-arm64.tar.gz", "10dba44cf95c7aa7abc3c72610c12ebcaf7cad6eed761d5ad92736ca3bc0d547"),
        "linux_arm": ("go1.12.1.linux-armv6l.tar.gz", "ceac33f07f8fdbccd6c6f7339db33479e1be8c206e67458ba259470fe796dbf2"),
        "linux_ppc64le": ("go1.12.1.linux-ppc64le.tar.gz", "e1258c81f420c88339abf40888423904c0023497b4e9bbffac9ee484597a57d3"),
        "linux_s390x": ("go1.12.1.linux-s390x.tar.gz", "a9b8f49be6b2083e2586c2ce8a2a86d5dbf47cca64ac6195546a81c9927f9513"),
        "windows_386": ("go1.12.1.windows-386.zip", "f424dd3340c5739a87cfd1f836d387df69cecddce2a94f14a057261bb7068172"),
        "windows_amd64": ("go1.12.1.windows-amd64.zip", "2f4849b512fffb2cf2028608aa066cc1b79e730fd146c7b89015797162f08ec5"),
    },
    "1.12": {
        "darwin_amd64": ("go1.12.darwin-amd64.tar.gz", "6c7e07349403f71588ef4e93a6d4ae31f8e5de1497a0a42fd998fe9b6bd07c8e"),
        "freebsd_386": ("go1.12.freebsd-386.tar.gz", "5f66cc122e91249d9b371b2c8635b0b50db513812e3efaf9d6defbc28bff3a1c"),
        "freebsd_amd64": ("go1.12.freebsd-amd64.tar.gz", "b4c063a3f39de4f837475cb982507926d7cab4f64d35e1dc0d6dce555b3fe143"),
        "linux_386": ("go1.12.linux-386.tar.gz", "3ac1db65a6fa5c13f424b53ee181755429df0c33775733cede1e0d540440fd7b"),
        "linux_amd64": ("go1.12.linux-amd64.tar.gz", "750a07fef8579ae4839458701f4df690e0b20b8bcce33b437e4df89c451b6f13"),
        "linux_arm64": ("go1.12.linux-arm64.tar.gz", "b7bf59c2f1ac48eb587817a2a30b02168ecc99635fc19b6e677cce01406e3fac"),
        "linux_arm": ("go1.12.linux-armv6l.tar.gz", "ea0636f055763d309437461b5817452419411eb1f598dc7f35999fae05bcb79a"),
        "linux_ppc64le": ("go1.12.linux-ppc64le.tar.gz", "5be21e7035efa4a270802ea04fb104dc7a54e3492641ae44632170b93166fb68"),
        "linux_s390x": ("go1.12.linux-s390x.tar.gz", "c0aef360b99ebb4b834db8b5b22777b73a11fa37b382121b24bf587c40603915"),
        "windows_386": ("go1.12.windows-386.zip", "c6606bfdc4d8b080fc40f72a072eb380ead77a02a4f99a6b953df6d9c7029970"),
        "windows_amd64": ("go1.12.windows-amd64.zip", "880ced1aecef08b3471a84381b6c7e2c0e846b81dd97ecb629b534d941f282bd"),
    },
    "1.11.11": {
        "darwin_amd64": ("go1.11.11.darwin-amd64.tar.gz", "7b235cc8a51b68d2370e629aacb60226e5791e33f4c6bf2abb30b43817149450"),
        "freebsd_386": ("go1.11.11.freebsd-386.tar.gz", "96be77e7f3bbe87bef174c4d2854c09cfe96d7c97888eb11a9702db6b5038320"),
        "freebsd_amd64": ("go1.11.11.freebsd-amd64.tar.gz", "77e08891f254eb9b784427bcf1b2ec5bcf1bc53c1f6bcccf630a889a55df8f6d"),
        "linux_386": ("go1.11.11.linux-386.tar.gz", "c711fe5025608e14bcd0efda9403e9b8f05cb4a53a125e296d639c10d280a65f"),
        "linux_amd64": ("go1.11.11.linux-amd64.tar.gz", "2fd47b824d6e32154b0f6c8742d066d816667715763e06cebb710304b195c775"),
        "linux_arm64": ("go1.11.11.linux-arm64.tar.gz", "5ee39ea08e5d8c017658f36d0f969b17a44d49576214f4a00710f2d98bb773be"),
        "linux_arm": ("go1.11.11.linux-armv6l.tar.gz", "c2b882a5fbb3bac5c9cc6d65bfe17a5febfe0251a339fc059306bb825dec9b17"),
        "linux_ppc64le": ("go1.11.11.linux-ppc64le.tar.gz", "98ff7ff2367239e26745231aabeaf9d7e51c40b616bb9aa15d4376792ff581d1"),
        "linux_s390x": ("go1.11.11.linux-s390x.tar.gz", "d7471874ed396f72dd550c3593c9f42d5e3d38a2cca7658e669305bf9023e6c8"),
        "windows_386": ("go1.11.11.windows-386.zip", "cbe55adb6f0748bfe8c0bbad8d42e311d0bd045300b5b3af2ff3a636211e359f"),
        "windows_amd64": ("go1.11.11.windows-amd64.zip", "38018a1a0fa341687cee2f71c0e7578f852bbf017ad48907cda6cc28d1b84140"),
    },
    "1.11.10": {
        "darwin_amd64": ("go1.11.10.darwin-amd64.tar.gz", "194d7ce2b88a791147be64860f21bac8eeec8f372c9e9caab6c72c3bd525a039"),
        "freebsd_386": ("go1.11.10.freebsd-386.tar.gz", "5e90549194981e78a6d222c9a1f882952309f36fc93021173a1c179ec292de03"),
        "freebsd_amd64": ("go1.11.10.freebsd-amd64.tar.gz", "cccd4951358735d0acb7e67e8db842062a51f348c471d222d7b9b1e87877e109"),
        "linux_386": ("go1.11.10.linux-386.tar.gz", "619ddab5b56597d72681467810c63238063ab0d221fe0df9b2e85608c10161e5"),
        "linux_amd64": ("go1.11.10.linux-amd64.tar.gz", "aefaa228b68641e266d1f23f1d95dba33f17552ba132878b65bb798ffa37e6d0"),
        "linux_arm64": ("go1.11.10.linux-arm64.tar.gz", "6743c54f0e33873c113cbd66df7749e81785f378567734831c2e5d3b6b6aa2b8"),
        "linux_arm": ("go1.11.10.linux-armv6l.tar.gz", "29812e3443c469de6b976e4e44b5e6402d55f6358a544278addc22446a0abe8b"),
        "linux_ppc64le": ("go1.11.10.linux-ppc64le.tar.gz", "a6c7129e92fe325645229846257e563dab1d970bb0e61820d63524df2b54fcf8"),
        "linux_s390x": ("go1.11.10.linux-s390x.tar.gz", "35f196abd74db6f049018829ea6230fde6b8c2e24d2da9f9e75ce0e6d0292b49"),
        "windows_386": ("go1.11.10.windows-386.zip", "a74ca1c26c8c73a6b0843a82630da69f43e7f71aad8171a40e5872cc3b06913f"),
        "windows_amd64": ("go1.11.10.windows-amd64.zip", "e0354b5cef18dbf5867fff022ed4264c441df504f3cb86c90d8b987eca336f78"),
    },
    "1.11.9": {
        "darwin_amd64": ("go1.11.9.darwin-amd64.tar.gz", "6b842edbd72ffc0c1243a8f4bbbc8b0fd0b44dd0176b0203eb8ebf9dd7057006"),
        "freebsd_386": ("go1.11.9.freebsd-386.tar.gz", "2f58d4fb7d94cd0947f36d9422e20a3d4aba95dd3eec9826a9828194a13eb8a5"),
        "freebsd_amd64": ("go1.11.9.freebsd-amd64.tar.gz", "10da27ca2ab83399417e08ad78b5770de594c96c1cdb809d2d8df4d36959f263"),
        "linux_386": ("go1.11.9.linux-386.tar.gz", "0fa4001fcf1ef0644e261bf6dde02fc9f10ae4df6d74fda61fc4d3c3cbef1d79"),
        "linux_amd64": ("go1.11.9.linux-amd64.tar.gz", "e88aa3e39104e3ba6a95a4e05629348b4a1ec82791fb3c941a493ca349730608"),
        "linux_arm64": ("go1.11.9.linux-arm64.tar.gz", "892ab6c2510c4caa5905b3b1b6a1d4c6f04e384841fec50881ca2be7e8accf05"),
        "linux_armv6l": ("go1.11.9.linux-armv6l.tar.gz", "f0d7b039cae61efdc346669f3459460e3dc03b6c6de528ca107fc53970cba0d1"),
        "linux_ppc64le": ("go1.11.9.linux-ppc64le.tar.gz", "6a0a6a80997529543a434667f404ead2da88ac8fecc59bfba82f62bd2588e6c8"),
        "linux_s390x": ("go1.11.9.linux-s390x.tar.gz", "0dd7073469d0f414b264fbadc4f720f9582b13ff6a0a978a9ef23020f9e42ac1"),
        "windows_386": ("go1.11.9.windows-386.zip", "ce999ecbd89375592de1536718be4307fbc9fdccde860a5cc388b5d471b6af59"),
        "windows_amd64": ("go1.11.9.windows-amd64.zip", "f3f3e3c428131d5be65d79cf8663b3a81b6675e5cf9780c3b0769cfca6824922"),
    },
    "1.11.8": {
        "darwin_amd64": ("go1.11.8.darwin-amd64.tar.gz", "2bbd6ddc3e74bbadc2d2700a9372be1a82816b3de6c6c4915825d631c317c11d"),
        "freebsd_386": ("go1.11.8.freebsd-386.tar.gz", "ff029f93abde0880c201789389e4da0c43bdf8cddd45b6ddb1c999db33e40190"),
        "freebsd_amd64": ("go1.11.8.freebsd-amd64.tar.gz", "e5183aedcf3a8e1a5acb608833d2652c24d450c4b00b51a94be352190e272a26"),
        "linux_386": ("go1.11.8.linux-386.tar.gz", "e0e62a02516fa2197a2eb319a6957e7bd7007005a11b4da5c6650879999db899"),
        "linux_amd64": ("go1.11.8.linux-amd64.tar.gz", "e32ab1c934b747999d04e8a550b97f4647f8b1b43e152de5650d4476bfd1d2e1"),
        "linux_arm64": ("go1.11.8.linux-arm64.tar.gz", "68c42239d118b27f5e52a449f444c8a53e64a181b12d9ecbda14d0c3b765a5ee"),
        "linux_arm": ("go1.11.8.linux-armv6l.tar.gz", "c5d4fd90242761c214124eedb0ffc35af52be19e7a4eb4006b036b5dcb422c87"),
        "linux_ppc64le": ("go1.11.8.linux-ppc64le.tar.gz", "4f0559832957c37022f771420902c1f19100c0a5b391c4957753c521a9eba56e"),
        "linux_s390x": ("go1.11.8.linux-s390x.tar.gz", "023928ee1d896af181c62acfd0a4e7bd713c8503a9b3b9aec745a3a830630e1b"),
        "windows_386": ("go1.11.8.windows-386.zip", "4c9e043790d9f477f23a90ac8cfbaffa46953ee8ba888152cf5b72a249688e6f"),
        "windows_amd64": ("go1.11.8.windows-amd64.zip", "6b9d9f18ace455dcec2e72a0c6740fb23fe5f39433df3522b76ce05dcdcb1808"),
    },
    "1.11.7": {
        "darwin_amd64": ("go1.11.7.darwin-amd64.tar.gz", "61059849b936e4987d0ad800c05357624cd2085748e3889c0ea29def4f0275ae"),
        "freebsd_386": ("go1.11.7.freebsd-386.tar.gz", "2e64f5b1510ba3789114d8853dcbfb8cfaac87323352c4dd06d9f95dbbecc2f3"),
        "freebsd_amd64": ("go1.11.7.freebsd-amd64.tar.gz", "30d99a0934d44878608dea3de8db59824ed56881c517a273450d7ba0cc124090"),
        "linux_386": ("go1.11.7.linux-386.tar.gz", "86d11a58bd99298719cb7ebea160255aefc56735d14089d2b2241d581967a482"),
        "linux_amd64": ("go1.11.7.linux-amd64.tar.gz", "db687814288b3b541c1754dfd4ecc2b8fd0d5e7995624945e3054a350ca573d8"),
        "linux_arm64": ("go1.11.7.linux-arm64.tar.gz", "fe7ba5046aa4f52ae8fa36531aac4a949ad8e10c02b0f4aa05a420b4e803f8c6"),
        "linux_armv6l": ("go1.11.7.linux-armv6l.tar.gz", "7d6ae2e119a432a4b00a6dc2c2085f56ead4973f40d58e534308f1535b45afc2"),
        "linux_ppc64le": ("go1.11.7.linux-ppc64le.tar.gz", "43b04f58b37808f86f526e6f1a8d6643fe196c1314acc3d7db710ec9ae960d18"),
        "linux_s390x": ("go1.11.7.linux-s390x.tar.gz", "178932743c7af70c94f170f800202f490e0f85e74796dabe0a23d50630ba0333"),
        "windows_386": ("go1.11.7.windows-386.zip", "ae166b92ce5f2d878e5f375685bfbce6322f72bdbd98b2ec710f2449faeca3a8"),
        "windows_amd64": ("go1.11.7.windows-amd64.zip", "7d2a8f2f90f4e989bd3fcb8ab70949a0a3cdb0ed416cd9f61768b4cfc214c09e"),
    },
    "1.11.6": {
        "darwin_amd64": ("go1.11.6.darwin-amd64.tar.gz", "3f1d8af129ee362990b98ba8a77ed9a595fd497d4c934e01d8cdd902d18cc97a"),
        "freebsd_386": ("go1.11.6.freebsd-386.tar.gz", "7a9e639ab153e86b9202193255b2ab21708ea2a5078735c1fe6a7023b7e104b0"),
        "freebsd_amd64": ("go1.11.6.freebsd-amd64.tar.gz", "27cfee907a4d83614b8ffeb122a3e238821c9e9287d04c126658c635cc91a5c7"),
        "linux_386": ("go1.11.6.linux-386.tar.gz", "7d90e484bb92e68648c1a7b6b1790e97af33718bae457d2ee02ee5d1dd0ce2b7"),
        "linux_amd64": ("go1.11.6.linux-amd64.tar.gz", "4e1864282d8d20010d6385a12a1e35641783a380a7c57907bfb46a5499c5eb49"),
        "linux_arm64": ("go1.11.6.linux-arm64.tar.gz", "29f64505cea47c57a46e2c8001ecf8d0c01cbf1ec86de96f4e3126b94a12ebb7"),
        "linux_arm": ("go1.11.6.linux-armv6l.tar.gz", "62597fe72f1170cbb939958823555a701510e00362eb8a10b7ace6e59c8e7e6e"),
        "linux_ppc64le": ("go1.11.6.linux-ppc64le.tar.gz", "43d7cc7d3cdc1e57af33a13296b48713735f55e25aa655187afb19a707143c77"),
        "linux_s390x": ("go1.11.6.linux-s390x.tar.gz", "c7f83fa5975a8f11641962bad79f89a7e17a6580d0d21ca828733dc0cfe470f7"),
        "windows_386": ("go1.11.6.windows-386.zip", "11a2903eb117820931a995b3288b66aa2c176f6c45def12c854fecf4d9c7f69b"),
        "windows_amd64": ("go1.11.6.windows-amd64.zip", "a91a1efb00028b222445f4bcb6c84548bbd74962e53c87b68f0bce65de29c1ae"),
    },
    "1.11.5": {
        "darwin_amd64": ("go1.11.5.darwin-amd64.tar.gz", "b970d8fdd5245193073395ce7b7775dd9deea980d4ce5e68b3b80ee9edcf2afc"),
        "freebsd_386": ("go1.11.5.freebsd-386.tar.gz", "29d208de22cf4561404f4e4866cbb3d937d1043ce65e0a4e4bb88a8c8ac754ea"),
        "freebsd_amd64": ("go1.11.5.freebsd-amd64.tar.gz", "edd594da33d497a3499b362af3a3b3281c2e1de2b68b869154d4151aa82d85e2"),
        "linux_386": ("go1.11.5.linux-386.tar.gz", "acd8e05f8d3eed406e09bb58eab89de3f0a139d4aef15f74adeed2d2c24cb440"),
        "linux_amd64": ("go1.11.5.linux-amd64.tar.gz", "ff54aafedff961eb94792487e827515da683d61a5f9482f668008832631e5d25"),
        "linux_arm64": ("go1.11.5.linux-arm64.tar.gz", "6ee9a5714444182a236d3cc4636e74cfc5e24a1bacf0463ac71dcf0e7d4288ed"),
        "linux_arm": ("go1.11.5.linux-armv6l.tar.gz", "b26b53c94923f78955236386fee0725ef4e76b6cb47e0df0ed0c0c4724e7b198"),
        "linux_ppc64le": ("go1.11.5.linux-ppc64le.tar.gz", "66e83152c68cb35d41f21453377d6a811585c9e01a6ac54b19f7a6e2cbb3d1f5"),
        "linux_s390x": ("go1.11.5.linux-s390x.tar.gz", "56209e5498c64a8338cd6f0fe0c2e2cbf6857c0acdb10c774894f0cc0d19f413"),
        "windows_386": ("go1.11.5.windows-386.zip", "b569f7a45056ab810364d7ac9ee6357e9a098fc3e4c75e016948736fa93ee229"),
        "windows_amd64": ("go1.11.5.windows-amd64.zip", "1c734fe614fa052f44694e993f2d06f24a56b6703ee46fdfb2b9bf277819fe40"),
    },
    "1.11.4": {
        "darwin_amd64": ("go1.11.4.darwin-amd64.tar.gz", "48ea987fb610894b3108ecf42e7a4fd1c1e3eabcaeb570e388c75af1f1375f80"),
        "freebsd_386": ("go1.11.4.freebsd-386.tar.gz", "7c302a5fcb25c7a4d370e856218b748994bbb129810306260293cdfba0a80650"),
        "freebsd_amd64": ("go1.11.4.freebsd-amd64.tar.gz", "e5a99add3e60e38ef559e211584bb09a883ccc46a6fb1432dcaa9fd052689b71"),
        "linux_386": ("go1.11.4.linux-386.tar.gz", "cecd2da1849043237d5f0756a93d601db6798fa3bb27a14563d201088aa415f3"),
        "linux_amd64": ("go1.11.4.linux-amd64.tar.gz", "fb26c30e6a04ad937bbc657a1b5bba92f80096af1e8ee6da6430c045a8db3a5b"),
        "linux_arm64": ("go1.11.4.linux-arm64.tar.gz", "b76df430ba8caff197b8558921deef782cdb20b62fa36fa93f81a8c08ab7c8e7"),
        "linux_arm": ("go1.11.4.linux-armv6l.tar.gz", "9f7a71d27fef69f654a93e265560c8d9db1a2ca3f1dcdbe5288c46facfde5821"),
        "linux_ppc64le": ("go1.11.4.linux-ppc64le.tar.gz", "1f10146826acd56716b00b9188079af53823ddd79ceb6362e78e2f3aafb370ab"),
        "linux_s390x": ("go1.11.4.linux-s390x.tar.gz", "4467442dacf89eb94c5d6f9f700204cb360be82db60e6296cc2ef8d0e890cd42"),
        "windows_386": ("go1.11.4.windows-386.zip", "bc25ea25406878986f91c92ae802f25f033cb0163b4aeac7e7185f71d0ede788"),
        "windows_amd64": ("go1.11.4.windows-amd64.zip", "eeb20e21702f2b9469d9381df5de85e2f731b64a1f54effe196d0f7d0227fe14"),
    },
    "1.11.3": {
        "darwin_amd64": ("go1.11.3.darwin-amd64.tar.gz", "3d164d44fcb06a4bbd69d19d8d91308d601f7d855a1037346389644803fdf148"),
        "freebsd_386": ("go1.11.3.freebsd-386.tar.gz", "2b4aacf3dc09c8b210fe3daf00f7c17c97d29503070200ba46e04f2d93790672"),
        "freebsd_amd64": ("go1.11.3.freebsd-amd64.tar.gz", "29b3fcc8d80ac1ea10cd82ca78d3dac4e7242333b882855ea7bc8e3a9d974116"),
        "linux_386": ("go1.11.3.linux-386.tar.gz", "c3fadf7f8652c060e18b7907fb8e15b853955b25aa661dbd991f6d6bc581d7a9"),
        "linux_amd64": ("go1.11.3.linux-amd64.tar.gz", "d20a4869ffb13cee0f7ee777bf18c7b9b67ef0375f93fac1298519e0c227a07f"),
        "linux_arm64": ("go1.11.3.linux-arm64.tar.gz", "723c54cb081dd629a44d620197e4a789dccdfe6dee7f8b4ad7a6659f76952056"),
        "linux_arm": ("go1.11.3.linux-armv6l.tar.gz", "384933e6e97b74c5125011c8f0539362bbed5a015978a34e441d7333d8e519b9"),
        "linux_ppc64le": ("go1.11.3.linux-ppc64le.tar.gz", "57c89a047ef4f539580af4cadebf1364a906891b065afa0664592e72a034b0ee"),
        "linux_s390x": ("go1.11.3.linux-s390x.tar.gz", "183258709c051ceb2900dee5ee681abb0bc440624c8f657374bde2a5658bef27"),
        "windows_386": ("go1.11.3.windows-386.zip", "07a38035d642ae81820551ce486f2ac7d541c0caf910659452b4661656db0691"),
        "windows_amd64": ("go1.11.3.windows-amd64.zip", "bc168207115eb0686e226ed3708337b161946c1acb0437603e1221e94f2e1f0f"),
    },
    "1.11.2": {
        "darwin_amd64": ("go1.11.2.darwin-amd64.tar.gz", "be2a9382ef85792280951a78e789e8891ddb1df4ac718cd241ea9d977c85c683"),
        "freebsd_386": ("go1.11.2.freebsd-386.tar.gz", "7daf8c1995e6eb343c4b487ba4d6b8fb5463cdead8a8bde867a25cc7168ff77b"),
        "freebsd_amd64": ("go1.11.2.freebsd-amd64.tar.gz", "a0b46726b102067bdd9a9b863f2bce4d23e4478118162bb9b2362733eb28cabf"),
        "linux_386": ("go1.11.2.linux-386.tar.gz", "e74f2f37b43b9b1bcf18008a11e0efb8921b41dff399a4f48ac09a4f25729881"),
        "linux_amd64": ("go1.11.2.linux-amd64.tar.gz", "1dfe664fa3d8ad714bbd15a36627992effd150ddabd7523931f077b3926d736d"),
        "linux_arm64": ("go1.11.2.linux-arm64.tar.gz", "98a42b9b8d3bacbcc6351a1e39af52eff582d0bc3ac804cd5a97ce497dd84026"),
        "linux_arm": ("go1.11.2.linux-armv6l.tar.gz", "b9d16a8eb1f7b8fdadd27232f6300aa8b4427e5e4cb148c4be4089db8fb56429"),
        "linux_ppc64le": ("go1.11.2.linux-ppc64le.tar.gz", "23291935a299fdfde4b6a988ce3faa0c7a498aab6d56bbafbf1e7476468529a3"),
        "linux_s390x": ("go1.11.2.linux-s390x.tar.gz", "a67ef820ef8cfecc8d68c69dd5bf513aaf647c09b6605570af425bf5fe8a32f0"),
        "windows_386": ("go1.11.2.windows-386.zip", "c0c5ab568d9cf260cd7d281e0a489ef91f4b943813d99dac78b61607dca17283"),
        "windows_amd64": ("go1.11.2.windows-amd64.zip", "086c59df0dce54d88f30edd50160393deceb27e73b8d6b46b9ee3f88b0c02e28"),
    },
    "1.11.1": {
        "darwin_amd64": ("go1.11.1.darwin-amd64.tar.gz", "1f2b29c8b08a140f06c88d055ad68104ccea9ca75fd28fbc95fe1eeb61a29bef"),
        "freebsd_386": ("go1.11.1.freebsd-386.tar.gz", "db02787955495a4128811705dabf1b09c6d9674d59ebf93bc7be40a1ead7d91f"),
        "freebsd_amd64": ("go1.11.1.freebsd-amd64.tar.gz", "b2618f92bf5365c3e4f2a1f82997505d6356364310fdc0b9137734c4c9df29d8"),
        "linux_386": ("go1.11.1.linux-386.tar.gz", "52935db83719739d84a389a8f3b14544874fba803a316250b8d596313283aadf"),
        "linux_amd64": ("go1.11.1.linux-amd64.tar.gz", "2871270d8ff0c8c69f161aaae42f9f28739855ff5c5204752a8d92a1c9f63993"),
        "linux_arm64": ("go1.11.1.linux-arm64.tar.gz", "25e1a281b937022c70571ac5a538c9402dd74bceb71c2526377a7e5747df5522"),
        "linux_arm": ("go1.11.1.linux-armv6l.tar.gz", "bc601e428f458da6028671d66581b026092742baf6d3124748bb044c82497d42"),
        "linux_ppc64le": ("go1.11.1.linux-ppc64le.tar.gz", "f929d434d6db09fc4c6b67b03951596e576af5d02ff009633ca3c5be1c832bdd"),
        "linux_s390x": ("go1.11.1.linux-s390x.tar.gz", "93afc048ad72fa2a0e5ec56bcdcd8a34213eb262aee6f39a7e4dfeeb7e564c9d"),
        "windows_386": ("go1.11.1.windows-386.zip", "5cc3681c954e23d40b0c2565765ec34f4b4e834348e03e1d1e6fd1c3a75b8202"),
        "windows_amd64": ("go1.11.1.windows-amd64.zip", "230a08d4260ded9d769f072512a49bffe8bfaff8323e839c2db7cf7c9c788130"),
    },
    "1.11": {
        "darwin_amd64": ("go1.11.darwin-amd64.tar.gz", "9749e6cb9c6d05cf10445a7c9899b58e72325c54fee9783ed1ac679be8e1e073"),
        "freebsd_386": ("go1.11.freebsd-386.tar.gz", "e4c2a9bd43932cb8f3226e866737e4a0f8cdda93db9d82754a0ffea04af1a259"),
        "freebsd_amd64": ("go1.11.freebsd-amd64.tar.gz", "535a7561a229bfe7bece68c8e315421fd9fbbd3a599b461944113c8d8240b28f"),
        "linux_386": ("go1.11.linux-386.tar.gz", "1a91932b65b4af2f84ef2dce10d790e6a0d3d22c9ea1bdf3d8c4d9279dfa680e"),
        "linux_amd64": ("go1.11.linux-amd64.tar.gz", "b3fcf280ff86558e0559e185b601c9eade0fd24c900b4c63cd14d1d38613e499"),
        "linux_arm64": ("go1.11.linux-arm64.tar.gz", "e4853168f41d0bea65e4d38f992a2d44b58552605f623640c5ead89d515c56c9"),
        "linux_arm": ("go1.11.linux-armv6l.tar.gz", "8ffeb3577d8ca5477064f1cb8739835973c866487f2bf81df1227eaa96826acd"),
        "linux_ppc64le": ("go1.11.linux-ppc64le.tar.gz", "e874d617f0e322f8c2dda8c23ea3a2ea21d5dfe7177abb1f8b6a0ac7cd653272"),
        "linux_s390x": ("go1.11.linux-s390x.tar.gz", "c113495fbb175d6beb1b881750de1dd034c7ae8657c30b3de8808032c9af0a15"),
        "windows_386": ("go1.11.windows-386.zip", "d3279f0e3d728637352eff0aa1e11268a0eb01f13644bcbce1c066139f5a90db"),
        "windows_amd64": ("go1.11.windows-amd64.zip", "29f9291270f0b303d0b270f993972ead215b1bad3cc674a0b8a09699d978aeb4"),
    },
    "1.10.8": {
        "darwin_amd64": ("go1.10.8.darwin-amd64.tar.gz", "f41bc914a721ac98a187df824b3b40f0a7f35bfb3c6d31221bdd940d537d3c28"),
        "freebsd_386": ("go1.10.8.freebsd-386.tar.gz", "029219c9588fd6af498898e783963c7ce3489270304987c561990d8d01169d7b"),
        "freebsd_amd64": ("go1.10.8.freebsd-amd64.tar.gz", "fc1ab404793cb9322e6e7348c274bf7d3562cc8bfb7b17e3b7c6e5787c89da2b"),
        "linux_386": ("go1.10.8.linux-386.tar.gz", "10202da0b7f2a0f2c2ec4dd65375584dd829ce88ccc58e5fe1fa1352e69fecaf"),
        "linux_amd64": ("go1.10.8.linux-amd64.tar.gz", "d8626fb6f9a3ab397d88c483b576be41fa81eefcec2fd18562c87626dbb3c39e"),
        "linux_arm64": ("go1.10.8.linux-arm64.tar.gz", "0921a76e78022ec2ae217e85b04940e2e9912b4c3218d96a827deedb9abe1c7b"),
        "linux_arm": ("go1.10.8.linux-armv6l.tar.gz", "6fdbc67524fc4c15fc87014869dddce9ecda7958b78f3cb1bbc5b0a9b61bfb95"),
        "linux_ppc64le": ("go1.10.8.linux-ppc64le.tar.gz", "9054bcc7582ebb8a69ca43447a38e4b9ea11d08f05511cc7f13720e3a12ff299"),
        "linux_s390x": ("go1.10.8.linux-s390x.tar.gz", "6f71b189c6cf30f7736af21265e992990cb0374138b7a70b0880cf8579399a69"),
        "windows_386": ("go1.10.8.windows-386.zip", "9ded97d830bef3734ea6de70df0159656d6a63e01484175b34d72b8db326bda0"),
        "windows_amd64": ("go1.10.8.windows-amd64.zip", "ab63b55c349f75cce4b93aefa9b52828f50ebafb302da5057db0e686d7873d7a"),
    },
    "1.10.7": {
        "darwin_amd64": ("go1.10.7.darwin-amd64.tar.gz", "700725a36d29d6e5d474a887acbf490c3d2762d719bdfef8370e22198077297d"),
        "freebsd_386": ("go1.10.7.freebsd-386.tar.gz", "d45bd54c38169ba228a67a17c92560e5a455405f6f5116a030c512510b06987c"),
        "freebsd_amd64": ("go1.10.7.freebsd-amd64.tar.gz", "21c9bda5fa37d668348e65b2374de6da84c85d601e45bbba4d8e2c86450f2a95"),
        "linux_386": ("go1.10.7.linux-386.tar.gz", "55cd25e550cb8ce8250dbc9eda56b9c10b3097c7f6beed45066fbaaf8c6c1ebd"),
        "linux_amd64": ("go1.10.7.linux-amd64.tar.gz", "1aabe10919048822f3bb1865f7a22f8b78387a12c03cd573101594bc8fb33579"),
        "linux_arm64": ("go1.10.7.linux-arm64.tar.gz", "cb5a274f7c8f6186957e4503e724dda8aeffe84b76a146748c55ea5bb22d9ae4"),
        "linux_arm": ("go1.10.7.linux-armv6l.tar.gz", "1f81c995f829c8fc7def4d0cc1bde63cac1834386e6f650f2cd7be56ab5e8b98"),
        "linux_ppc64le": ("go1.10.7.linux-ppc64le.tar.gz", "11279ffebfcfa875b0552839d428cc72e2056e68681286429b57173c0da91fb4"),
        "linux_s390x": ("go1.10.7.linux-s390x.tar.gz", "e0d7802029ed8d2720a2b27ec1816e71cb29f818380abb8b449080e97547881e"),
        "windows_386": ("go1.10.7.windows-386.zip", "bbd297a456aded5dcafe91194aafec883802cd0982120c735d15a39810248ea7"),
        "windows_amd64": ("go1.10.7.windows-amd64.zip", "791e2d5a409932157ac87f4da7fa22d5e5468b784d5933121e4a747d89639e15"),
    },
    "1.10.6": {
        "darwin_amd64": ("go1.10.6.darwin-amd64.tar.gz", "419e7a775c39074ff967b4e66fa212eb4fd310b1f15675ce13977b57635dd3a8"),
        "freebsd_386": ("go1.10.6.freebsd-386.tar.gz", "d1f0aef497588865967256030cb676c6c62f6a4b53649814e753ae150fbaa960"),
        "freebsd_amd64": ("go1.10.6.freebsd-amd64.tar.gz", "194a1a39a96bb8d7ed8370dae7768db47109f628aea4f1588f677f66c384955a"),
        "linux_386": ("go1.10.6.linux-386.tar.gz", "171fe6cbecb2845b875a35ac7ad758d4c0c5bd03f330fa35d340de85b9070e71"),
        "linux_amd64": ("go1.10.6.linux-amd64.tar.gz", "acbdedf28b55b38d2db6f06209a25a869a36d31bdcf09fd2ec3d40e1279e0592"),
        "linux_arm64": ("go1.10.6.linux-arm64.tar.gz", "0fcbfbcbf6373c0b6876786900a4a100c1ed9af86bd3258f23ab498cca4c02a1"),
        "linux_arm": ("go1.10.6.linux-armv6l.tar.gz", "4da252fc7e834b7ce35d349fb581aa84a08adece926a0b9a8e4216451ffcb11e"),
        "linux_ppc64le": ("go1.10.6.linux-ppc64le.tar.gz", "ebd7e4688f3e1baabbc735453b19c6c27116e1f292bf46622123bfc4c160c747"),
        "linux_s390x": ("go1.10.6.linux-s390x.tar.gz", "0223daa57bdef5bf85d308f6d2793c58055d294c13cbaca240ead2f568de2e9f"),
        "windows_386": ("go1.10.6.windows-386.zip", "2f3ded109a37d53bd8600fa23c07d9abea41fb30a5f5954bbc97e9c57d8e0ce0"),
        "windows_amd64": ("go1.10.6.windows-amd64.zip", "fc57f16c23b7fb41b664f549ff2ed6cca340555e374c5ff52fa296cd3f228f32"),
    },
    "1.10.5": {
        "darwin_amd64": ("go1.10.5.darwin-amd64.tar.gz", "36873d9935f7f3519da11c9e928b66c94ccbf71c37df71b7635e804a226ae631"),
        "freebsd_386": ("go1.10.5.freebsd-386.tar.gz", "6533503d07f1f966966d5342584eca036aea72339af6da3b2db74bee94df8ac1"),
        "freebsd_amd64": ("go1.10.5.freebsd-amd64.tar.gz", "a742a8a2feec059ee32d79c9d72a11c87857619eb6d4fa7910c62a49901142c4"),
        "linux_386": ("go1.10.5.linux-386.tar.gz", "bc1bd42405a551ba7ac86b79b9d23a5635f21de53caf684acd8bf5dfee8bef5d"),
        "linux_amd64": ("go1.10.5.linux-amd64.tar.gz", "a035d9beda8341b645d3f45a1b620cf2d8fb0c5eb409be36b389c0fd384ecc3a"),
        "linux_arm64": ("go1.10.5.linux-arm64.tar.gz", "b4c16fcee18bc79de2fa4776c8d0f9bc164ddfc32101e96fe1da83ebe881e3df"),
        "linux_arm": ("go1.10.5.linux-armv6l.tar.gz", "1d864a6d0ec599de9112c8354dcaaa886b4df928757966939402598e9bd9c238"),
        "linux_ppc64le": ("go1.10.5.linux-ppc64le.tar.gz", "8fc13736d383312710249b24adf05af59ff14dacb73d9bd715ff463bc89c5c5f"),
        "linux_s390x": ("go1.10.5.linux-s390x.tar.gz", "e90269495fab7ef99aea6937caf7a049896b2dc7b181456f80a506e69a8b57fc"),
        "windows_386": ("go1.10.5.windows-386.zip", "e936532cc0d3ea9470129ba6df3714924fbc709a9441209a8154503cf16823f2"),
        "windows_amd64": ("go1.10.5.windows-amd64.zip", "d88a32eb4d1fc3b11253c9daa2ef397c8700f3ba493b41324b152e6cda44d2b4"),
    },
    "1.10.4": {
        "darwin_amd64": ("go1.10.4.darwin-amd64.tar.gz", "2ba324f01de2b2ece0376f6d696570a4c5c13db67d00aadfd612adc56feff587"),
        "freebsd_386": ("go1.10.4.freebsd-386.tar.gz", "d2d375daf6352e7b2d4f0dc8a90d1dbc463b955221b9d87fb1fbde805c979bb2"),
        "freebsd_amd64": ("go1.10.4.freebsd-amd64.tar.gz", "ad2fbf6ab2d1754f4ae5d8f6488bdcc6cc48dd15cac29207f38f7cbf0978ed17"),
        "linux_386": ("go1.10.4.linux-386.tar.gz", "771f48e55776d4abc9c2a74907457066c7c282ac05fa01cf5ff4422ced76d2ee"),
        "linux_amd64": ("go1.10.4.linux-amd64.tar.gz", "fa04efdb17a275a0c6e137f969a1c4eb878939e91e1da16060ce42f02c2ec5ec"),
        "linux_arm64": ("go1.10.4.linux-arm64.tar.gz", "2e0f9e99aeefaabba280b2bf85db0336da122accde73603159b3d72d0b2bd512"),
        "linux_arm": ("go1.10.4.linux-armv6l.tar.gz", "4e1e80bd98f3598c0c48ba0c189c836d01b602bfc769b827a4bfed01d2c14b21"),
        "linux_ppc64le": ("go1.10.4.linux-ppc64le.tar.gz", "1cfc147357c0be91a988998046997c5f30b20c6baaeb6cd5774717714db76093"),
        "linux_s390x": ("go1.10.4.linux-s390x.tar.gz", "5593d770d6544090c1bb20d57bb34c743131470695e195fbe5352bf056927a35"),
        "windows_386": ("go1.10.4.windows-386.zip", "407e5619048c427de4a65b26edb17d54c220f8c30ebd358961b1785a38394ec9"),
        "windows_amd64": ("go1.10.4.windows-amd64.zip", "5499aa98399664df8dc1da5c3aaaed14b3130b79c713b5677a0ee9e93854476c"),
    },
    "1.10.3": {
        "darwin_amd64": ("go1.10.3.darwin-amd64.tar.gz", "131fd430350a3134d352ee75c5ca456cdf4443e492d0527a9651c7c04e2b458d"),
        "freebsd_386": ("go1.10.3.freebsd-386.tar.gz", "92a28ccd8caa173295490dfd3f1d10f3bc7eaf0953bf099631bc6c57a5842704"),
        "freebsd_amd64": ("go1.10.3.freebsd-amd64.tar.gz", "231d9e6f3b5acee1193cd18b98c89f1a51570fbc8ba7c6c6b67a7f7ff2985e2b"),
        "linux_386": ("go1.10.3.linux-386.tar.gz", "3d5fe1932c904a01acb13dae07a5835bffafef38bef9e5a05450c52948ebdeb4"),
        "linux_amd64": ("go1.10.3.linux-amd64.tar.gz", "fa1b0e45d3b647c252f51f5e1204aba049cde4af177ef9f2181f43004f901035"),
        "linux_arm64": ("go1.10.3.linux-arm64.tar.gz", "355128a05b456c9e68792143801ad18e0431510a53857f640f7b30ba92624ed2"),
        "linux_arm": ("go1.10.3.linux-armv6l.tar.gz", "d3df3fa3d153e81041af24f31a82f86a21cb7b92c1b5552fb621bad0320f06b6"),
        "linux_ppc64le": ("go1.10.3.linux-ppc64le.tar.gz", "f3640b2f0990a9617c937775f669ee18f10a82e424e5f87a8ce794a6407b8347"),
        "linux_s390x": ("go1.10.3.linux-s390x.tar.gz", "34385f64651f82fbc11dc43bdc410c2abda237bdef87f3a430d35a508ec3ce0d"),
        "windows_386": ("go1.10.3.windows-386.zip", "89696a29bdf808fa9861216a21824ae8eb2e750a54b1424ce7f2a177e5cd1466"),
        "windows_amd64": ("go1.10.3.windows-amd64.zip", "a3f19d4fc0f4b45836b349503e347e64e31ab830dedac2fc9c390836d4418edb"),
    },
    "1.10.2": {
        "darwin_amd64": ("go1.10.2.darwin-amd64.tar.gz", "360ad908840217ee1b2a0b4654666b9abb3a12c8593405ba88ab9bba6e64eeda"),
        "freebsd_386": ("go1.10.2.freebsd-386.tar.gz", "f272774839a95041cf8874171ef6a8c6692e8784544ca05abbb29c66643d24a9"),
        "freebsd_amd64": ("go1.10.2.freebsd-amd64.tar.gz", "6174ff4c2da7ebb064e7f2b28419d2cd5d3f7de34bec9e42d3716bdb190c9955"),
        "linux_386": ("go1.10.2.linux-386.tar.gz", "ea4caddf76b86ed5d101a61bc9a273be5b24d81f0567270bb4d5beaaded9b567"),
        "linux_amd64": ("go1.10.2.linux-amd64.tar.gz", "4b677d698c65370afa33757b6954ade60347aaca310ea92a63ed717d7cb0c2ff"),
        "linux_arm64": ("go1.10.2.linux-arm64.tar.gz", "d6af66c71b12d63c754d5bf49c3007dc1c9821eb1a945118bfd5a539a327c4c8"),
        "linux_arm": ("go1.10.2.linux-armv6l.tar.gz", "529a16b531d4561572db6ba9d357215b58a1953437a63e76dc0c597be9e25dd2"),
        "linux_ppc64le": ("go1.10.2.linux-ppc64le.tar.gz", "f0748502c90e9784b6368937f1d157913d18acdae72ac75add50e5c0c9efc85c"),
        "linux_s390x": ("go1.10.2.linux-s390x.tar.gz", "2266b7ebdbca13c21a1f6039c9f6887cd2c01617d1e2716ff4595307a0da1d46"),
        "windows_386": ("go1.10.2.windows-386.zip", "0bb12875044674d632d1f1b2f53cf33510a6df914178fe672f3f70f6f6cdf80d"),
        "windows_amd64": ("go1.10.2.windows-amd64.zip", "0fb4a893796e8151c0b8d0a3da4ed8cbb22bf6d98a3c29c915be4d7083f146ee"),
    },
    "1.10.1": {
        "darwin_amd64": ("go1.10.1.darwin-amd64.tar.gz", "0a5bbcbbb0d150338ba346151d2864fd326873beaedf964e2057008c8a4dc557"),
        "linux_386": ("go1.10.1.linux-386.tar.gz", "acbe19d56123549faf747b4f61b730008b185a0e2145d220527d2383627dfe69"),
        "linux_amd64": ("go1.10.1.linux-amd64.tar.gz", "72d820dec546752e5a8303b33b009079c15c2390ce76d67cf514991646c6127b"),
        "linux_arm": ("go1.10.1.linux-armv6l.tar.gz", "feca4e920d5ca25001dc0823390df79bc7ea5b5b8c03483e5a2c54f164654936"),
        "windows_386": ("go1.10.1.windows-386.zip", "2f09edd066cc929bb362262afab27609e8d4b96f7dfd3f3844238e3214db9b8a"),
        "windows_amd64": ("go1.10.1.windows-amd64.zip", "17f7664131202b469f4264161ff3cd0796e8398249d2b646bbe4990301afc678"),
        "freebsd_386": ("go1.10.1.freebsd-386.tar.gz", "3e7f0967348d554ebe385f2372411ecfdbdc3074c8ff3ccb9f2910a765c4e472"),
        "freebsd_amd64": ("go1.10.1.freebsd-amd64.tar.gz", "41f57f91363c81523ec23d4a25f0ba92bd66a8c1a35b6df82491a8413bd2cd62"),
        "linux_arm64": ("go1.10.1.linux-arm64.tar.gz", "1e07a159414b5090d31166d1a06ee501762076ef21140dcd54cdcbe4e68a9c9b"),
        "linux_ppc64le": ("go1.10.1.linux-ppc64le.tar.gz", "91d0026bbed601c4aad332473ed02f9a460b31437cbc6f2a37a88c0376fc3a65"),
        "linux_s390x": ("go1.10.1.linux-s390x.tar.gz", "e211a5abdacf843e16ac33a309d554403beb63959f96f9db70051f303035434b"),
    },
    "1.10": {
        "darwin_amd64": ("go1.10.darwin-amd64.tar.gz", "511a4799e8d64cda3352bb7fe72e359689ea6ef0455329cda6b6e1f3137326c1"),
        "linux_386": ("go1.10.linux-386.tar.gz", "2d26a9f41fd80eeb445cc454c2ba6b3d0db2fc732c53d7d0427a9f605bfc55a1"),
        "linux_amd64": ("go1.10.linux-amd64.tar.gz", "b5a64335f1490277b585832d1f6c7f8c6c11206cba5cd3f771dcb87b98ad1a33"),
        "linux_arm": ("go1.10.linux-armv6l.tar.gz", "6ff665a9ab61240cf9f11a07e03e6819e452a618a32ea05bbb2c80182f838f4f"),
        "windows_386": ("go1.10.windows-386.zip", "83edd9e52ce6d1c8f911e7bbf6f0a73952c613b4bf66438ceb1507f892240f11"),
        "windows_amd64": ("go1.10.windows-amd64.zip", "210b223031c254a6eb8fa138c3782b23af710a9959d64b551fa81edd762ea167"),
        "freebsd_386": ("go1.10.freebsd-386.tar.gz", "d1e84cc46fa7290a6849c794785d629239f07c6f3e565616fa5421dd51344211"),
        "freebsd_amd64": ("go1.10.freebsd-amd64.tar.gz", "9ecc9dd288e9727b9ed250d5adbcf21073c038391e8d96aff46c20800be317c3"),
        "linux_arm64": ("go1.10.linux-arm64.tar.gz", "efb47e5c0e020b180291379ab625c6ec1c2e9e9b289336bc7169e6aa1da43fd8"),
        "linux_ppc64le": ("go1.10.linux-ppc64le.tar.gz", "a1e22e2fbcb3e551e0bf59d0f8aeb4b3f2df86714f09d2acd260c6597c43beee"),
        "linux_s390x": ("go1.10.linux-s390x.tar.gz", "71cde197e50afe17f097f81153edb450f880267699f22453272d184e0f4681d7"),
    },
}

_label_prefix = "@io_bazel_rules_go//go/toolchain:"

def go_register_toolchains(go_version = DEFAULT_VERSION, nogo = None):
    """See /go/toolchains.rst#go-register-toolchains for full documentation."""
    if "go_sdk" not in native.existing_rules():
        if go_version in SDK_REPOSITORIES:
            if not versions.is_at_least(MIN_SUPPORTED_VERSION, go_version):
                print("DEPRECATED: go_register_toolchains: support for Go versions before {} will be removed soon".format(MIN_SUPPORTED_VERSION))
            go_download_sdk(
                name = "go_sdk",
                sdks = SDK_REPOSITORIES[go_version],
            )
        elif go_version == "host":
            go_host_sdk(
                name = "go_sdk",
            )
        else:
            fail("Unknown go version {}".format(go_version))

    if nogo:
        # Override default definition in go_rules_dependencies().
        go_register_nogo(
            name = "io_bazel_rules_nogo",
            nogo = nogo,
        )

def declare_constraints():
    for goos, constraint in GOOS.items():
        if constraint:
            native.alias(
                name = goos,
                actual = constraint,
            )
        else:
            native.constraint_value(
                name = goos,
                constraint_setting = "@bazel_tools//platforms:os",
            )
    for goarch, constraint in GOARCH.items():
        if constraint:
            native.alias(
                name = goarch,
                actual = constraint,
            )
        else:
            native.constraint_value(
                name = goarch,
                constraint_setting = "@bazel_tools//platforms:cpu",
            )
    for goos, goarch in GOOS_GOARCH:
        native.platform(
            name = goos + "_" + goarch,
            constraint_values = [
                ":" + goos,
                ":" + goarch,
            ],
        )

def declare_toolchains(host, sdk, builder):
    # Use the final dictionaries to create all the toolchains
    for toolchain in generate_toolchains(host, sdk, builder):
        go_toolchain(**toolchain)

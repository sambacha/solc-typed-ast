pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;
pragma experimental SMTChecker;

enum GlobalEnum { A, B, C }

struct GlobalStruct {
    int a;
    uint[] b;
    mapping(address => uint) c;
    mapping(GlobalEnum => address) e;
    mapping(Empty => bool) d;
}

/// Sample library
///   Contains testSignedBaseExponentiation()
library SampleLibrary {
    function testSignedBaseExponentiation(int base, uint pow) public returns (int) {
        return (base ** pow);
    }
}

/// Sample interface
///   Contains infFunc() that returns `bytes memory`
interface SampleInterface {
    function infFunc(string calldata x) external returns (bytes memory);
}

abstract contract SampleAbstract {
    int internal some;

    /// An abtract overridable modifier
    modifier abstractMod(int a) virtual;

    constructor(int v) public {
        some = v;
    }

    function abstractFunc(address a) virtual internal returns (address payable);
}

/// Empty contract
///   Just a stub
contract Empty {}

contract EmptyPayable {
    constructor() public payable {}
}

contract SampleBase is SampleAbstract(1) {
    /// Alert event for particular address
    event Alert(address entity, string message);

    uint internal constant constVar = 0;
    uint internal immutable immutableVar1 = 1;
    uint public immutable immutableVar2;
    uint[] internal data;

    /// An implementation of the abstract modifier
    modifier abstractMod(int a) override {
        _;
        some += a;
    }

    /// Modifier that requires `some` to be positive
    ///   before the function execution.
    modifier onlyPositiveSomeBefore() {
        require(some > 0, "Failure");
        _;
    }

    modifier alertingAfter(string memory message) {
        _;
        emit Alert(address(this), message);
    }

    constructor(uint v) public {
        immutableVar2 = v;
    }

    function abstractFunc(address a) override internal returns (address payable) {
        return payable(a);
    }

    function internalCallback() internal pure {}

    function testMinMax() public {
        assert(type(uint).min == 0);
        assert(type(uint).max == 115792089237316195423570985008687907853269984665640564039457584007913129639935);
        assert(type(int256).min == (-57896044618658097711785492504343953926634992332820282019728792003956564819968));
        assert(type(int256).max == 57896044618658097711785492504343953926634992332820282019728792003956564819967);
    }

    /// Interface ID (ERC-165)
    function testInterfaceId() public pure returns (bytes4) {
        return type(SampleInterface).interfaceId;
    }

    /// @dev tests calldata slicing
    function testSlices() public pure {
        (uint a, uint b) = abi.decode(msg.data[0:4], (uint, uint));
        (uint c, uint d) = abi.decode(msg.data[:4], (uint, uint));
        (uint e, uint f) = abi.decode(msg.data[4:], (uint, uint));
        (uint g, uint h) = abi.decode(msg.data[:], (uint, uint));
        (uint i, uint j) = abi.decode(msg.data, (uint, uint));
    }

    function testTryCatch() public alertingAfter("Other contract creation") {
        try new Empty() {
            int a = 1;
        } catch  {
            int b = 2;
        }
        try new EmptyPayable{salt: 0x0, value: 1 ether}() returns (EmptyPayable x) {
            int a = 1;
        } catch Error(string memory reason) {} catch (bytes memory lowLevelData) {}
    }

    function testGWei() public {
        assert(1 gwei == 1000000000 wei);
        assert(1 gwei == 0.001 szabo);
    }

    function basicFunctionality() internal onlyPositiveSomeBefore() returns (uint) {
        function(address) internal returns (address payable) converter = SampleBase.abstractFunc;
        function() internal pure sel = SampleBase.internalCallback;
        uint[] memory nums = new uint[](3);
        nums[0] = 1;
        nums[1] = 2;
        nums[2] = 3;
        GlobalStruct memory a = GlobalStruct(1, nums);
        uint[] memory x = a.b;
        delete a;
        uint y = x[1];
        delete x;
        return y;
    }

    function testSelectors() public {
        this.testSlices.selector;
        SampleLibrary.testSignedBaseExponentiation.selector;
        SampleInterface.infFunc.selector;
    }

    function testUnassignedStorage(uint[] memory x) internal returns (uint[] memory) {
        data = x;
        uint[] storage s;
        s = data;
        return s;
    }

    receive() external payable {}

    fallback() external {}
}

contract CallDataUsage {
    /// State variable doc string
    uint[] internal values;

    function returnRow(uint[][] calldata rows, uint index) private pure returns (uint[] calldata) {
        require(rows.length > index, "Rows does not contain index");
        uint[] calldata row = rows[index];
        return row;
    }

    function addOwners(uint[][] calldata rows) public {
        uint[] calldata row = returnRow(rows, 0);
        checkUnique(row);
        for (uint i = 0; i < row.length; i++) {
            values.push(row[i]);
        }
    }

    function checkUnique(uint[] calldata newValues) internal pure {
        for (uint i = 0; i < newValues.length; i++) {
            for (uint j = i + 1; i < newValues.length; j++) {
                require(newValues[i] != newValues[i]);
            }
        }
    }
}

interface SomeInterface {
    function addr() external pure returns (address payable);
}

contract PublicVarOverride is SomeInterface {
    /// State variable overriding interface function by getter.
    address payable public immutable override addr = address(0x0);
}
// PragmaDirective#1 (168:23:0) -> 0:23:0
// PragmaDirective#2 (192:33:0) -> 24:33:0
// PragmaDirective#3 (226:31:0) -> 58:31:0
// EnumValue#4 (277:1:0) -> 109:1:0
// EnumValue#5 (280:1:0) -> 112:1:0
// EnumValue#6 (283:1:0) -> 115:1:0
// EnumDefinition#7 (259:27:0) -> 91:27:0
// ElementaryTypeName#8 (314:3:0) -> 146:3:0
// VariableDeclaration#9 (314:5:0) -> 146:5:0
// ElementaryTypeName#10 (325:4:0) -> 157:4:0
// ArrayTypeName#11 (325:6:0) -> 157:6:0
// VariableDeclaration#12 (325:8:0) -> 157:8:0
// ElementaryTypeName#13 (347:7:0) -> 179:7:0
// ElementaryTypeName#14 (358:4:0) -> 190:4:0
// Mapping#15 (339:24:0) -> 171:24:0
// VariableDeclaration#16 (339:26:0) -> 171:26:0
// UserDefinedTypeName#17 (379:10:0) -> 211:10:0
// ElementaryTypeName#18 (393:7:0) -> 225:7:0
// Mapping#19 (371:30:0) -> 203:30:0
// VariableDeclaration#20 (371:32:0) -> 203:32:0
// UserDefinedTypeName#21 (417:5:0) -> 249:5:0
// ElementaryTypeName#22 (426:4:0) -> 258:4:0
// Mapping#23 (409:22:0) -> 241:22:0
// VariableDeclaration#24 (409:24:0) -> 241:24:0
// StructDefinition#25 (288:148:0) -> 120:148:0
// StructuredDocumentation#26 (438:65:0) -> 270:65:0
// ElementaryTypeName#27 (569:3:0) -> 401:3:0
// VariableDeclaration#28 (569:8:0) -> 401:8:0
// ElementaryTypeName#29 (579:4:0) -> 411:4:0
// VariableDeclaration#30 (579:8:0) -> 411:8:0
// ParameterList#31 (568:20:0) -> 400:20:0
// ElementaryTypeName#32 (605:3:0) -> 437:3:0
// VariableDeclaration#33 (605:3:0) -> 437:3:0
// ParameterList#34 (604:5:0) -> 436:5:0
// Identifier#35 (628:4:0) -> 460:4:0
// Identifier#36 (636:3:0) -> 468:3:0
// BinaryOperation#37 (628:11:0) -> 460:11:0
// TupleExpression#38 (627:13:0) -> 459:13:0
// Return#39 (620:20:0) -> 452:20:0
// Block#40 (610:37:0) -> 442:37:0
// FunctionDefinition#41 (531:116:0) -> 363:116:0
// ContractDefinition#42 (503:146:0) -> 335:146:0
// StructuredDocumentation#43 (651:74:0) -> 483:74:0
// ElementaryTypeName#44 (774:6:0) -> 606:6:0
// VariableDeclaration#45 (774:17:0) -> 606:17:0
// ParameterList#46 (773:19:0) -> 605:19:0
// ElementaryTypeName#47 (811:5:0) -> 643:5:0
// VariableDeclaration#48 (811:12:0) -> 643:12:0
// ParameterList#49 (810:14:0) -> 642:14:0
// FunctionDefinition#50 (757:68:0) -> 589:68:0
// ContractDefinition#51 (725:102:0) -> 557:102:0
// ElementaryTypeName#52 (868:3:0) -> 700:3:0
// VariableDeclaration#53 (868:17:0) -> 700:17:0
// StructuredDocumentation#54 (892:36:0) -> 724:40:0
// ElementaryTypeName#55 (954:3:0) -> 785:3:0
// VariableDeclaration#56 (954:5:0) -> 785:5:0
// ParameterList#57 (953:7:0) -> 784:7:0
// ModifierDefinition#58 (933:36:0) -> 764:36:0
// ElementaryTypeName#59 (987:3:0) -> 818:3:0
// VariableDeclaration#60 (987:5:0) -> 818:5:0
// ParameterList#61 (986:7:0) -> 817:7:0
// Identifier#63 (1011:4:0) -> 842:4:0
// Identifier#64 (1018:1:0) -> 849:1:0
// Assignment#65 (1011:8:0) -> 842:8:0
// ExpressionStatement#66 (1011:8:0) -> 842:8:0
// Block#67 (1001:25:0) -> 832:25:0
// FunctionDefinition#68 (975:51:0) -> 806:51:0
// ElementaryTypeName#69 (1054:7:0) -> 885:7:0
// VariableDeclaration#70 (1054:9:0) -> 885:9:0
// ParameterList#71 (1053:11:0) -> 884:11:0
// ElementaryTypeName#72 (1091:15:0) -> 922:15:0
// VariableDeclaration#73 (1091:15:0) -> 922:15:0
// ParameterList#74 (1090:17:0) -> 921:17:0
// FunctionDefinition#75 (1032:76:0) -> 863:76:0
// ContractDefinition#76 (829:281:0) -> 661:280:0
// StructuredDocumentation#77 (1112:36:0) -> 943:37:0
// ContractDefinition#78 (1148:17:0) -> 980:17:0
// ParameterList#79 (1206:2:0) -> 1038:2:0
// Block#81 (1224:2:0) -> 1056:2:0
// FunctionDefinition#82 (1195:31:0) -> 1027:31:0
// ContractDefinition#83 (1167:61:0) -> 999:61:0
// UserDefinedTypeName#84 (1253:14:0) -> 1085:14:0
// Literal#85 (1268:1:0) -> 1100:1:0
// InheritanceSpecifier#86 (1253:17:0) -> 1085:17:0
// StructuredDocumentation#87 (1277:38:0) -> 1109:43:0
// ElementaryTypeName#88 (1332:7:0) -> 1164:7:0
// VariableDeclaration#89 (1332:14:0) -> 1164:14:0
// ElementaryTypeName#90 (1348:6:0) -> 1180:6:0
// VariableDeclaration#91 (1348:14:0) -> 1180:14:0
// ParameterList#92 (1331:32:0) -> 1163:32:0
// EventDefinition#93 (1320:44:0) -> 1152:44:0
// ElementaryTypeName#94 (1370:4:0) -> 1202:4:0
// Literal#95 (1404:1:0) -> 1236:1:0
// VariableDeclaration#96 (1370:35:0) -> 1202:35:0
// ElementaryTypeName#97 (1411:4:0) -> 1243:4:0
// Literal#98 (1451:1:0) -> 1283:1:0
// VariableDeclaration#99 (1411:41:0) -> 1243:41:0
// ElementaryTypeName#100 (1458:4:0) -> 1290:4:0
// VariableDeclaration#101 (1458:35:0) -> 1290:35:0
// ElementaryTypeName#102 (1499:4:0) -> 1331:4:0
// ArrayTypeName#103 (1499:6:0) -> 1331:6:0
// VariableDeclaration#104 (1499:20:0) -> 1331:20:0
// StructuredDocumentation#105 (1526:47:0) -> 1358:51:0
// ElementaryTypeName#106 (1599:3:0) -> 1430:3:0
// VariableDeclaration#107 (1599:5:0) -> 1430:5:0
// ParameterList#108 (1598:7:0) -> 1429:7:0
// OverrideSpecifier#109 (1606:8:0) -> 1437:8:0
// PlaceholderStatement#110 (1625:1:0) -> 1456:1:0
// Identifier#111 (1636:4:0) -> 1467:4:0
// Identifier#112 (1644:1:0) -> 1475:1:0
// Assignment#113 (1636:9:0) -> 1467:9:0
// ExpressionStatement#114 (1636:9:0) -> 1467:9:0
// Block#115 (1615:37:0) -> 1446:37:0
// ModifierDefinition#116 (1578:74:0) -> 1409:74:0
// StructuredDocumentation#117 (1658:89:0) -> 1489:94:0
// ParameterList#118 (1783:2:0) -> 1614:2:0
// Identifier#119 (1796:7:0) -> 1627:7:0
// Identifier#120 (1804:4:0) -> 1635:4:0
// Literal#121 (1811:1:0) -> 1642:1:0
// BinaryOperation#122 (1804:8:0) -> 1635:8:0
// Literal#123 (1814:9:0) -> 1645:9:0
// FunctionCall#124 (1796:28:0) -> 1627:28:0
// ExpressionStatement#125 (1796:28:0) -> 1627:28:0
// PlaceholderStatement#126 (1834:1:0) -> 1665:1:0
// Block#127 (1786:56:0) -> 1617:56:0
// ModifierDefinition#128 (1752:90:0) -> 1583:90:0
// ElementaryTypeName#129 (1871:6:0) -> 1702:6:0
// VariableDeclaration#130 (1871:21:0) -> 1702:21:0
// ParameterList#131 (1870:23:0) -> 1701:23:0
// PlaceholderStatement#132 (1904:1:0) -> 1735:1:0
// Identifier#133 (1920:5:0) -> 1751:5:0
// ElementaryTypeName#134 (1926:7:0) -> 1757:7:0
// ElementaryTypeNameExpression#135 (1926:7:0) -> 1757:7:0
// Identifier#136 (1934:4:0) -> 1765:4:0
// FunctionCall#137 (1926:13:0) -> 1757:13:0
// Identifier#138 (1941:7:0) -> 1772:7:0
// FunctionCall#139 (1920:29:0) -> 1751:29:0
// EmitStatement#140 (1915:34:0) -> 1746:34:0
// Block#141 (1894:62:0) -> 1725:62:0
// ModifierDefinition#142 (1848:108:0) -> 1679:108:0
// ElementaryTypeName#143 (1974:4:0) -> 1805:4:0
// VariableDeclaration#144 (1974:6:0) -> 1805:6:0
// ParameterList#145 (1973:8:0) -> 1804:8:0
// Identifier#147 (1999:13:0) -> 1830:13:0
// Identifier#148 (2015:1:0) -> 1846:1:0
// Assignment#149 (1999:17:0) -> 1830:17:0
// ExpressionStatement#150 (1999:17:0) -> 1830:17:0
// Block#151 (1989:34:0) -> 1820:34:0
// FunctionDefinition#152 (1962:61:0) -> 1793:61:0
// ElementaryTypeName#153 (2051:7:0) -> 1882:7:0
// VariableDeclaration#154 (2051:9:0) -> 1882:9:0
// ParameterList#155 (2050:11:0) -> 1881:11:0
// OverrideSpecifier#156 (2062:8:0) -> 1893:8:0
// ElementaryTypeName#157 (2089:15:0) -> 1920:15:0
// VariableDeclaration#158 (2089:15:0) -> 1920:15:0
// ParameterList#159 (2088:17:0) -> 1919:17:0
// ElementaryTypeName#160 (2123:8:0) -> 1954:7:0
// ElementaryTypeNameExpression#161 (2123:8:0) -> 1954:7:0
// Identifier#162 (2131:1:0) -> 1962:1:0
// FunctionCall#163 (2123:10:0) -> 1954:10:0
// Return#164 (2116:17:0) -> 1947:17:0
// Block#165 (2106:34:0) -> 1937:34:0
// FunctionDefinition#166 (2029:111:0) -> 1860:111:0
// ParameterList#167 (2171:2:0) -> 2002:2:0
// Block#169 (2188:2:0) -> 2019:2:0
// FunctionDefinition#170 (2146:44:0) -> 1977:44:0
// ParameterList#171 (2215:2:0) -> 2046:2:0
// Identifier#173 (2235:6:0) -> 2066:6:0
// Identifier#174 (2242:4:0) -> 2073:4:0
// ElementaryTypeName#175 (2247:4:0) -> 2078:4:0
// ElementaryTypeNameExpression#176 (2247:4:0) -> 2078:4:0
// FunctionCall#177 (2242:10:0) -> 2073:10:0
// MemberAccess#178 (2242:14:0) -> 2073:14:0
// Literal#179 (2260:1:0) -> 2091:1:0
// BinaryOperation#180 (2242:19:0) -> 2073:19:0
// FunctionCall#181 (2235:27:0) -> 2066:27:0
// ExpressionStatement#182 (2235:27:0) -> 2066:27:0
// Identifier#183 (2272:6:0) -> 2103:6:0
// Identifier#184 (2279:4:0) -> 2110:4:0
// ElementaryTypeName#185 (2284:4:0) -> 2115:4:0
// ElementaryTypeNameExpression#186 (2284:4:0) -> 2115:4:0
// FunctionCall#187 (2279:10:0) -> 2110:10:0
// MemberAccess#188 (2279:14:0) -> 2110:14:0
// Literal#189 (2297:78:0) -> 2128:78:0
// BinaryOperation#190 (2279:96:0) -> 2110:96:0
// FunctionCall#191 (2272:104:0) -> 2103:104:0
// ExpressionStatement#192 (2272:104:0) -> 2103:104:0
// Identifier#193 (2386:6:0) -> 2217:6:0
// Identifier#194 (2393:4:0) -> 2224:4:0
// ElementaryTypeName#195 (2398:6:0) -> 2229:6:0
// ElementaryTypeNameExpression#196 (2398:6:0) -> 2229:6:0
// FunctionCall#197 (2393:12:0) -> 2224:12:0
// MemberAccess#198 (2393:16:0) -> 2224:16:0
// Literal#199 (2415:77:0) -> 2246:77:0
// UnaryOperation#200 (2414:78:0) -> 2245:78:0
// TupleExpression#201 (2413:80:0) -> 2244:80:0
// BinaryOperation#202 (2393:100:0) -> 2224:100:0
// FunctionCall#203 (2386:108:0) -> 2217:108:0
// ExpressionStatement#204 (2386:108:0) -> 2217:108:0
// Identifier#205 (2504:6:0) -> 2335:6:0
// Identifier#206 (2511:4:0) -> 2342:4:0
// ElementaryTypeName#207 (2516:6:0) -> 2347:6:0
// ElementaryTypeNameExpression#208 (2516:6:0) -> 2347:6:0
// FunctionCall#209 (2511:12:0) -> 2342:12:0
// MemberAccess#210 (2511:16:0) -> 2342:16:0
// Literal#211 (2531:77:0) -> 2362:77:0
// BinaryOperation#212 (2511:97:0) -> 2342:97:0
// FunctionCall#213 (2504:105:0) -> 2335:105:0
// ExpressionStatement#214 (2504:105:0) -> 2335:105:0
// Block#215 (2225:391:0) -> 2056:391:0
// FunctionDefinition#216 (2196:420:0) -> 2027:420:0
// StructuredDocumentation#217 (2622:26:0) -> 2453:31:0
// ParameterList#218 (2677:2:0) -> 2508:2:0
// ElementaryTypeName#219 (2701:6:0) -> 2532:6:0
// VariableDeclaration#220 (2701:6:0) -> 2532:6:0
// ParameterList#221 (2700:8:0) -> 2531:8:0
// Identifier#222 (2726:4:0) -> 2557:4:0
// Identifier#223 (2731:15:0) -> 2562:15:0
// FunctionCall#224 (2726:21:0) -> 2557:21:0
// MemberAccess#225 (2726:33:0) -> 2557:33:0
// Return#226 (2719:40:0) -> 2550:40:0
// Block#227 (2709:57:0) -> 2540:57:0
// FunctionDefinition#228 (2653:113:0) -> 2484:113:0
// StructuredDocumentation#229 (2772:31:0) -> 2603:36:0
// ParameterList#230 (2827:2:0) -> 2658:2:0
// ElementaryTypeName#232 (2853:4:0) -> 2684:4:0
// VariableDeclaration#233 (2853:6:0) -> 2684:6:0
// ElementaryTypeName#234 (2861:4:0) -> 2692:4:0
// VariableDeclaration#235 (2861:6:0) -> 2692:6:0
// Identifier#236 (2871:3:0) -> 2702:3:0
// MemberAccess#237 (2871:10:0) -> 2702:10:0
// Identifier#238 (2882:3:0) -> 2713:3:0
// MemberAccess#239 (2882:8:0) -> 2713:8:0
// Literal#240 (2891:1:0) -> 2722:1:0
// Literal#241 (2893:1:0) -> 2724:1:0
// IndexRangeAccess#242 (2882:13:0) -> 2713:13:0
// ElementaryTypeName#243 (2898:4:0) -> 2729:4:0
// ElementaryTypeNameExpression#244 (2898:4:0) -> 2729:4:0
// ElementaryTypeName#245 (2904:4:0) -> 2735:4:0
// ElementaryTypeNameExpression#246 (2904:4:0) -> 2735:4:0
// TupleExpression#247 (2897:12:0) -> 2728:12:0
// FunctionCall#248 (2871:39:0) -> 2702:39:0
// VariableDeclarationStatement#249 (2852:58:0) -> 2683:58:0
// ElementaryTypeName#250 (2921:4:0) -> 2752:4:0
// VariableDeclaration#251 (2921:6:0) -> 2752:6:0
// ElementaryTypeName#252 (2929:4:0) -> 2760:4:0
// VariableDeclaration#253 (2929:6:0) -> 2760:6:0
// Identifier#254 (2939:3:0) -> 2770:3:0
// MemberAccess#255 (2939:10:0) -> 2770:10:0
// Identifier#256 (2950:3:0) -> 2781:3:0
// MemberAccess#257 (2950:8:0) -> 2781:8:0
// Literal#258 (2960:1:0) -> 2791:1:0
// IndexRangeAccess#259 (2950:12:0) -> 2781:12:0
// ElementaryTypeName#260 (2965:4:0) -> 2796:4:0
// ElementaryTypeNameExpression#261 (2965:4:0) -> 2796:4:0
// ElementaryTypeName#262 (2971:4:0) -> 2802:4:0
// ElementaryTypeNameExpression#263 (2971:4:0) -> 2802:4:0
// TupleExpression#264 (2964:12:0) -> 2795:12:0
// FunctionCall#265 (2939:38:0) -> 2770:38:0
// VariableDeclarationStatement#266 (2920:57:0) -> 2751:57:0
// ElementaryTypeName#267 (2988:4:0) -> 2819:4:0
// VariableDeclaration#268 (2988:6:0) -> 2819:6:0
// ElementaryTypeName#269 (2996:4:0) -> 2827:4:0
// VariableDeclaration#270 (2996:6:0) -> 2827:6:0
// Identifier#271 (3006:3:0) -> 2837:3:0
// MemberAccess#272 (3006:10:0) -> 2837:10:0
// Identifier#273 (3017:3:0) -> 2848:3:0
// MemberAccess#274 (3017:8:0) -> 2848:8:0
// Literal#275 (3026:1:0) -> 2857:1:0
// IndexRangeAccess#276 (3017:12:0) -> 2848:12:0
// ElementaryTypeName#277 (3032:4:0) -> 2863:4:0
// ElementaryTypeNameExpression#278 (3032:4:0) -> 2863:4:0
// ElementaryTypeName#279 (3038:4:0) -> 2869:4:0
// ElementaryTypeNameExpression#280 (3038:4:0) -> 2869:4:0
// TupleExpression#281 (3031:12:0) -> 2862:12:0
// FunctionCall#282 (3006:38:0) -> 2837:38:0
// VariableDeclarationStatement#283 (2987:57:0) -> 2818:57:0
// ElementaryTypeName#284 (3055:4:0) -> 2886:4:0
// VariableDeclaration#285 (3055:6:0) -> 2886:6:0
// ElementaryTypeName#286 (3063:4:0) -> 2894:4:0
// VariableDeclaration#287 (3063:6:0) -> 2894:6:0
// Identifier#288 (3073:3:0) -> 2904:3:0
// MemberAccess#289 (3073:10:0) -> 2904:10:0
// Identifier#290 (3084:3:0) -> 2915:3:0
// MemberAccess#291 (3084:8:0) -> 2915:8:0
// IndexRangeAccess#292 (3084:11:0) -> 2915:11:0
// ElementaryTypeName#293 (3098:4:0) -> 2929:4:0
// ElementaryTypeNameExpression#294 (3098:4:0) -> 2929:4:0
// ElementaryTypeName#295 (3104:4:0) -> 2935:4:0
// ElementaryTypeNameExpression#296 (3104:4:0) -> 2935:4:0
// TupleExpression#297 (3097:12:0) -> 2928:12:0
// FunctionCall#298 (3073:37:0) -> 2904:37:0
// VariableDeclarationStatement#299 (3054:56:0) -> 2885:56:0
// ElementaryTypeName#300 (3121:4:0) -> 2952:4:0
// VariableDeclaration#301 (3121:6:0) -> 2952:6:0
// ElementaryTypeName#302 (3129:4:0) -> 2960:4:0
// VariableDeclaration#303 (3129:6:0) -> 2960:6:0
// Identifier#304 (3139:3:0) -> 2970:3:0
// MemberAccess#305 (3139:10:0) -> 2970:10:0
// Identifier#306 (3150:3:0) -> 2981:3:0
// MemberAccess#307 (3150:8:0) -> 2981:8:0
// ElementaryTypeName#308 (3161:4:0) -> 2992:4:0
// ElementaryTypeNameExpression#309 (3161:4:0) -> 2992:4:0
// ElementaryTypeName#310 (3167:4:0) -> 2998:4:0
// ElementaryTypeNameExpression#311 (3167:4:0) -> 2998:4:0
// TupleExpression#312 (3160:12:0) -> 2991:12:0
// FunctionCall#313 (3139:34:0) -> 2970:34:0
// VariableDeclarationStatement#314 (3120:53:0) -> 2951:53:0
// Block#315 (2842:338:0) -> 2673:338:0
// FunctionDefinition#316 (2808:372:0) -> 2639:372:0
// ParameterList#317 (3207:2:0) -> 3038:2:0
// Identifier#318 (3217:13:0) -> 3048:13:0
// Literal#319 (3231:25:0) -> 3062:25:0
// ModifierInvocation#320 (3217:40:0) -> 3048:40:0
// UserDefinedTypeName#322 (3276:5:0) -> 3107:5:0
// NewExpression#323 (3272:9:0) -> 3103:9:0
// FunctionCall#324 (3272:11:0) -> 3103:11:0
// ElementaryTypeName#325 (3298:3:0) -> 3129:3:0
// VariableDeclaration#326 (3298:5:0) -> 3129:5:0
// Literal#327 (3306:1:0) -> 3137:1:0
// VariableDeclarationStatement#328 (3298:9:0) -> 3129:9:0
// Block#329 (3284:34:0) -> 3115:34:0
// TryCatchClause#330 (3284:34:0) -> 3115:34:0
// ElementaryTypeName#331 (3340:3:0) -> 3171:3:0
// VariableDeclaration#332 (3340:5:0) -> 3171:5:0
// Literal#333 (3348:1:0) -> 3179:1:0
// VariableDeclarationStatement#334 (3340:9:0) -> 3171:9:0
// Block#335 (3326:34:0) -> 3157:34:0
// TryCatchClause#336 (3319:41:0) -> 3150:41:0
// TryStatement#337 (3268:92:0) -> 3099:92:0
// UserDefinedTypeName#338 (3377:12:0) -> 3208:12:0
// NewExpression#339 (3373:16:0) -> 3204:16:0
// Literal#340 (3396:3:0) -> 3227:3:0
// Literal#341 (3408:7:0) -> 3239:7:0
// FunctionCallOptions#342 (3373:43:0) -> 3204:43:0
// FunctionCall#343 (3373:45:0) -> 3204:45:0
// UserDefinedTypeName#344 (3428:12:0) -> 3259:12:0
// VariableDeclaration#345 (3428:14:0) -> 3259:14:0
// ParameterList#346 (3427:16:0) -> 3258:16:0
// ElementaryTypeName#347 (3458:3:0) -> 3289:3:0
// VariableDeclaration#348 (3458:5:0) -> 3289:5:0
// Literal#349 (3466:1:0) -> 3297:1:0
// VariableDeclarationStatement#350 (3458:9:0) -> 3289:9:0
// Block#351 (3444:34:0) -> 3275:34:0
// TryCatchClause#352 (3419:59:0) -> 3250:59:0
// ElementaryTypeName#353 (3491:6:0) -> 3322:6:0
// VariableDeclaration#354 (3491:20:0) -> 3322:20:0
// ParameterList#355 (3490:22:0) -> 3321:22:0
// Block#356 (3513:2:0) -> 3344:2:0
// TryCatchClause#357 (3479:36:0) -> 3310:36:0
// ElementaryTypeName#358 (3523:5:0) -> 3354:5:0
// VariableDeclaration#359 (3523:25:0) -> 3354:25:0
// ParameterList#360 (3522:27:0) -> 3353:27:0
// Block#361 (3550:2:0) -> 3381:2:0
// TryCatchClause#362 (3516:36:0) -> 3347:36:0
// TryStatement#363 (3369:183:0) -> 3200:183:0
// Block#364 (3258:300:0) -> 3089:300:0
// FunctionDefinition#365 (3186:372:0) -> 3017:372:0
// ParameterList#366 (3581:2:0) -> 3412:2:0
// Identifier#368 (3601:6:0) -> 3432:6:0
// Literal#369 (3608:6:0) -> 3439:6:0
// Literal#370 (3618:14:0) -> 3449:14:0
// BinaryOperation#371 (3608:24:0) -> 3439:24:0
// FunctionCall#372 (3601:32:0) -> 3432:32:0
// ExpressionStatement#373 (3601:32:0) -> 3432:32:0
// Identifier#374 (3643:6:0) -> 3474:6:0
// Literal#375 (3650:6:0) -> 3481:6:0
// Literal#376 (3660:11:0) -> 3491:11:0
// BinaryOperation#377 (3650:21:0) -> 3481:21:0
// FunctionCall#378 (3643:29:0) -> 3474:29:0
// ExpressionStatement#379 (3643:29:0) -> 3474:29:0
// Block#380 (3591:88:0) -> 3422:88:0
// FunctionDefinition#381 (3564:115:0) -> 3395:115:0
// ParameterList#382 (3712:2:0) -> 3543:2:0
// Identifier#383 (3724:22:0) -> 3555:22:0
// ModifierInvocation#384 (3724:24:0) -> 3555:24:0
// ElementaryTypeName#385 (3758:4:0) -> 3589:4:0
// VariableDeclaration#386 (3758:4:0) -> 3589:4:0
// ParameterList#387 (3757:6:0) -> 3588:6:0
// ElementaryTypeName#388 (3783:7:0) -> 3614:7:0
// VariableDeclaration#389 (3783:7:0) -> 3614:7:0
// ParameterList#390 (3782:9:0) -> 3613:9:0
// ElementaryTypeName#391 (3810:15:0) -> 3641:15:0
// VariableDeclaration#392 (3810:15:0) -> 3641:15:0
// ParameterList#393 (3809:17:0) -> 3640:17:0
// FunctionTypeName#394 (3774:62:0) -> 3605:52:0
// VariableDeclaration#395 (3774:62:0) -> 3605:62:0
// Identifier#396 (3839:10:0) -> 3670:10:0
// MemberAccess#397 (3839:23:0) -> 3670:23:0
// VariableDeclarationStatement#398 (3774:88:0) -> 3605:88:0
// ParameterList#399 (3880:2:0) -> 3711:2:0
// FunctionTypeName#401 (3872:28:0) -> 3703:24:0
// VariableDeclaration#402 (3872:28:0) -> 3703:28:0
// Identifier#403 (3903:10:0) -> 3734:10:0
// MemberAccess#404 (3903:27:0) -> 3734:27:0
// VariableDeclarationStatement#405 (3872:58:0) -> 3703:58:0
// ElementaryTypeName#408 (3940:4:0) -> 3771:4:0
// ArrayTypeName#409 (3940:6:0) -> 3771:6:0
// VariableDeclaration#410 (3940:18:0) -> 3771:18:0
// ElementaryTypeName#411 (3965:4:0) -> 3796:4:0
// ArrayTypeName#412 (3965:6:0) -> 3796:6:0
// NewExpression#413 (3961:10:0) -> 3792:10:0
// Literal#414 (3972:1:0) -> 3803:1:0
// FunctionCall#415 (3961:13:0) -> 3792:13:0
// VariableDeclarationStatement#416 (3940:34:0) -> 3771:34:0
// Identifier#417 (3984:4:0) -> 3815:4:0
// Literal#418 (3989:1:0) -> 3820:1:0
// IndexAccess#419 (3984:7:0) -> 3815:7:0
// Literal#420 (3994:1:0) -> 3825:1:0
// Assignment#421 (3984:11:0) -> 3815:11:0
// ExpressionStatement#422 (3984:11:0) -> 3815:11:0
// Identifier#423 (4005:4:0) -> 3836:4:0
// Literal#424 (4010:1:0) -> 3841:1:0
// IndexAccess#425 (4005:7:0) -> 3836:7:0
// Literal#426 (4015:1:0) -> 3846:1:0
// Assignment#427 (4005:11:0) -> 3836:11:0
// ExpressionStatement#428 (4005:11:0) -> 3836:11:0
// Identifier#429 (4026:4:0) -> 3857:4:0
// Literal#430 (4031:1:0) -> 3862:1:0
// IndexAccess#431 (4026:7:0) -> 3857:7:0
// Literal#432 (4036:1:0) -> 3867:1:0
// Assignment#433 (4026:11:0) -> 3857:11:0
// ExpressionStatement#434 (4026:11:0) -> 3857:11:0
// UserDefinedTypeName#435 (4047:12:0) -> 3878:12:0
// VariableDeclaration#436 (4047:21:0) -> 3878:21:0
// Identifier#437 (4071:12:0) -> 3902:12:0
// Literal#438 (4084:1:0) -> 3915:1:0
// Identifier#439 (4087:4:0) -> 3918:4:0
// FunctionCall#440 (4071:21:0) -> 3902:21:0
// VariableDeclarationStatement#441 (4047:45:0) -> 3878:45:0
// ElementaryTypeName#444 (4102:4:0) -> 3933:4:0
// ArrayTypeName#445 (4102:6:0) -> 3933:6:0
// VariableDeclaration#446 (4102:15:0) -> 3933:15:0
// Identifier#447 (4120:1:0) -> 3951:1:0
// MemberAccess#448 (4120:3:0) -> 3951:3:0
// VariableDeclarationStatement#449 (4102:21:0) -> 3933:21:0
// Identifier#450 (4140:1:0) -> 3971:1:0
// UnaryOperation#451 (4133:8:0) -> 3964:8:0
// ExpressionStatement#452 (4133:8:0) -> 3964:8:0
// ElementaryTypeName#453 (4151:4:0) -> 3982:4:0
// VariableDeclaration#454 (4151:6:0) -> 3982:6:0
// Identifier#455 (4160:1:0) -> 3991:1:0
// Literal#456 (4162:1:0) -> 3993:1:0
// IndexAccess#457 (4160:4:0) -> 3991:4:0
// VariableDeclarationStatement#458 (4151:13:0) -> 3982:13:0
// Identifier#459 (4181:1:0) -> 4012:1:0
// UnaryOperation#460 (4174:8:0) -> 4005:8:0
// ExpressionStatement#461 (4174:8:0) -> 4005:8:0
// Identifier#462 (4199:1:0) -> 4030:1:0
// Return#463 (4192:8:0) -> 4023:8:0
// Block#464 (3764:443:0) -> 3595:443:0
// FunctionDefinition#465 (3685:522:0) -> 3516:522:0
// ParameterList#466 (4235:2:0) -> 4066:2:0
// Identifier#468 (4255:4:0) -> 4086:4:0
// MemberAccess#471 (4255:15:0) -> 4086:15:0
// MemberAccess#472 (4255:24:0) -> 4086:24:0
// ExpressionStatement#473 (4255:24:0) -> 4086:24:0
// Identifier#474 (4289:13:0) -> 4120:13:0
// MemberAccess#477 (4289:42:0) -> 4120:42:0
// MemberAccess#478 (4289:51:0) -> 4120:51:0
// ExpressionStatement#479 (4289:51:0) -> 4120:51:0
// Identifier#480 (4350:15:0) -> 4181:15:0
// MemberAccess#483 (4350:23:0) -> 4181:23:0
// MemberAccess#484 (4350:32:0) -> 4181:32:0
// ExpressionStatement#485 (4350:32:0) -> 4181:32:0
// Block#486 (4245:144:0) -> 4076:144:0
// FunctionDefinition#487 (4213:176:0) -> 4044:176:0
// ElementaryTypeName#488 (4426:4:0) -> 4257:4:0
// ArrayTypeName#489 (4426:6:0) -> 4257:6:0
// VariableDeclaration#490 (4426:15:0) -> 4257:15:0
// ParameterList#491 (4425:17:0) -> 4256:17:0
// ElementaryTypeName#492 (4461:4:0) -> 4292:4:0
// ArrayTypeName#493 (4461:6:0) -> 4292:6:0
// VariableDeclaration#494 (4461:13:0) -> 4292:13:0
// ParameterList#495 (4460:15:0) -> 4291:15:0
// Identifier#496 (4486:4:0) -> 4317:4:0
// Identifier#497 (4493:1:0) -> 4324:1:0
// Assignment#498 (4486:8:0) -> 4317:8:0
// ExpressionStatement#499 (4486:8:0) -> 4317:8:0
// ElementaryTypeName#502 (4504:4:0) -> 4335:4:0
// ArrayTypeName#503 (4504:6:0) -> 4335:6:0
// VariableDeclaration#504 (4504:16:0) -> 4335:16:0
// VariableDeclarationStatement#505 (4504:16:0) -> 4335:16:0
// Identifier#506 (4530:1:0) -> 4361:1:0
// Identifier#507 (4534:4:0) -> 4365:4:0
// Assignment#508 (4530:8:0) -> 4361:8:0
// ExpressionStatement#509 (4530:8:0) -> 4361:8:0
// Identifier#510 (4555:1:0) -> 4386:1:0
// Return#511 (4548:8:0) -> 4379:8:0
// Block#512 (4476:87:0) -> 4307:87:0
// FunctionDefinition#513 (4395:168:0) -> 4226:168:0
// ParameterList#514 (4576:2:0) -> 4407:2:0
// Block#516 (4596:2:0) -> 4427:2:0
// FunctionDefinition#517 (4569:29:0) -> 4400:29:0
// ParameterList#518 (4612:2:0) -> 4443:2:0
// Block#520 (4624:2:0) -> 4455:2:0
// FunctionDefinition#521 (4604:22:0) -> 4435:22:0
// ContractDefinition#522 (1230:3398:0) -> 1062:3397:0
// StructuredDocumentation#523 (4659:29:0) -> 4490:34:0
// ElementaryTypeName#524 (4693:4:0) -> 4524:4:0
// ArrayTypeName#525 (4693:6:0) -> 4524:6:0
// VariableDeclaration#526 (4693:22:0) -> 4524:22:0
// ElementaryTypeName#527 (4741:4:0) -> 4572:4:0
// ArrayTypeName#528 (4741:6:0) -> 4572:6:0
// ArrayTypeName#529 (4741:8:0) -> 4572:8:0
// VariableDeclaration#530 (4741:22:0) -> 4572:22:0
// ElementaryTypeName#531 (4765:4:0) -> 4596:4:0
// VariableDeclaration#532 (4765:10:0) -> 4596:10:0
// ParameterList#533 (4740:36:0) -> 4571:36:0
// ElementaryTypeName#534 (4799:4:0) -> 4630:4:0
// ArrayTypeName#535 (4799:6:0) -> 4630:6:0
// VariableDeclaration#536 (4799:15:0) -> 4630:15:0
// ParameterList#537 (4798:17:0) -> 4629:17:0
// Identifier#538 (4826:7:0) -> 4657:7:0
// Identifier#539 (4834:4:0) -> 4665:4:0
// MemberAccess#540 (4834:11:0) -> 4665:11:0
// Identifier#541 (4848:5:0) -> 4679:5:0
// BinaryOperation#542 (4834:19:0) -> 4665:19:0
// Literal#543 (4855:29:0) -> 4686:29:0
// FunctionCall#544 (4826:59:0) -> 4657:59:0
// ExpressionStatement#545 (4826:59:0) -> 4657:59:0
// ElementaryTypeName#548 (4895:4:0) -> 4726:4:0
// ArrayTypeName#549 (4895:6:0) -> 4726:6:0
// VariableDeclaration#550 (4895:19:0) -> 4726:19:0
// Identifier#551 (4917:4:0) -> 4748:4:0
// Identifier#552 (4922:5:0) -> 4753:5:0
// IndexAccess#553 (4917:11:0) -> 4748:11:0
// VariableDeclarationStatement#554 (4895:33:0) -> 4726:33:0
// Identifier#555 (4945:3:0) -> 4776:3:0
// Return#556 (4938:10:0) -> 4769:10:0
// Block#557 (4816:139:0) -> 4647:139:0
// FunctionDefinition#558 (4722:233:0) -> 4553:233:0
// ElementaryTypeName#559 (4980:4:0) -> 4811:4:0
// ArrayTypeName#560 (4980:6:0) -> 4811:6:0
// ArrayTypeName#561 (4980:8:0) -> 4811:8:0
// VariableDeclaration#562 (4980:22:0) -> 4811:22:0
// ParameterList#563 (4979:24:0) -> 4810:24:0
// ElementaryTypeName#567 (5021:4:0) -> 4852:4:0
// ArrayTypeName#568 (5021:6:0) -> 4852:6:0
// VariableDeclaration#569 (5021:19:0) -> 4852:19:0
// Identifier#570 (5043:9:0) -> 4874:9:0
// Identifier#571 (5053:4:0) -> 4884:4:0
// Literal#572 (5059:1:0) -> 4890:1:0
// FunctionCall#573 (5043:18:0) -> 4874:18:0
// VariableDeclarationStatement#574 (5021:40:0) -> 4852:40:0
// Identifier#575 (5071:11:0) -> 4902:11:0
// Identifier#576 (5083:3:0) -> 4914:3:0
// FunctionCall#577 (5071:16:0) -> 4902:16:0
// ExpressionStatement#578 (5071:16:0) -> 4902:16:0
// ElementaryTypeName#579 (5102:4:0) -> 4933:4:0
// VariableDeclaration#580 (5102:6:0) -> 4933:6:0
// Literal#581 (5111:1:0) -> 4942:1:0
// VariableDeclarationStatement#582 (5102:10:0) -> 4933:10:0
// Identifier#583 (5114:1:0) -> 4945:1:0
// Identifier#584 (5118:3:0) -> 4949:3:0
// MemberAccess#585 (5118:10:0) -> 4949:10:0
// BinaryOperation#586 (5114:14:0) -> 4945:14:0
// Identifier#587 (5130:1:0) -> 4961:1:0
// UnaryOperation#588 (5130:3:0) -> 4961:3:0
// ExpressionStatement#589 (5130:3:0) -> 4961:3:0
// Identifier#590 (5149:6:0) -> 4980:6:0
// MemberAccess#592 (5149:11:0) -> 4980:11:0
// Identifier#593 (5161:3:0) -> 4992:3:0
// Identifier#594 (5165:1:0) -> 4996:1:0
// IndexAccess#595 (5161:6:0) -> 4992:6:0
// FunctionCall#596 (5149:19:0) -> 4980:19:0
// ExpressionStatement#597 (5149:19:0) -> 4980:19:0
// Block#598 (5135:44:0) -> 4966:44:0
// ForStatement#599 (5097:82:0) -> 4928:82:0
// Block#600 (5011:174:0) -> 4842:174:0
// FunctionDefinition#601 (4961:224:0) -> 4792:224:0
// ElementaryTypeName#602 (5212:4:0) -> 5043:4:0
// ArrayTypeName#603 (5212:6:0) -> 5043:6:0
// VariableDeclaration#604 (5212:25:0) -> 5043:25:0
// ParameterList#605 (5211:27:0) -> 5042:27:0
// ElementaryTypeName#607 (5268:4:0) -> 5099:4:0
// VariableDeclaration#608 (5268:6:0) -> 5099:6:0
// Literal#609 (5277:1:0) -> 5108:1:0
// VariableDeclarationStatement#610 (5268:10:0) -> 5099:10:0
// Identifier#611 (5280:1:0) -> 5111:1:0
// Identifier#612 (5284:9:0) -> 5115:9:0
// MemberAccess#613 (5284:16:0) -> 5115:16:0
// BinaryOperation#614 (5280:20:0) -> 5111:20:0
// Identifier#615 (5302:1:0) -> 5133:1:0
// UnaryOperation#616 (5302:3:0) -> 5133:3:0
// ExpressionStatement#617 (5302:3:0) -> 5133:3:0
// ElementaryTypeName#618 (5326:4:0) -> 5157:4:0
// VariableDeclaration#619 (5326:6:0) -> 5157:6:0
// Identifier#620 (5335:1:0) -> 5166:1:0
// Literal#621 (5339:1:0) -> 5170:1:0
// BinaryOperation#622 (5335:5:0) -> 5166:5:0
// VariableDeclarationStatement#623 (5326:14:0) -> 5157:14:0
// Identifier#624 (5342:1:0) -> 5173:1:0
// Identifier#625 (5346:9:0) -> 5177:9:0
// MemberAccess#626 (5346:16:0) -> 5177:16:0
// BinaryOperation#627 (5342:20:0) -> 5173:20:0
// Identifier#628 (5364:1:0) -> 5195:1:0
// UnaryOperation#629 (5364:3:0) -> 5195:3:0
// ExpressionStatement#630 (5364:3:0) -> 5195:3:0
// Identifier#631 (5387:7:0) -> 5218:7:0
// Identifier#632 (5395:9:0) -> 5226:9:0
// Identifier#633 (5405:1:0) -> 5236:1:0
// IndexAccess#634 (5395:12:0) -> 5226:12:0
// Identifier#635 (5411:9:0) -> 5242:9:0
// Identifier#636 (5421:1:0) -> 5252:1:0
// IndexAccess#637 (5411:12:0) -> 5242:12:0
// BinaryOperation#638 (5395:28:0) -> 5226:28:0
// FunctionCall#639 (5387:37:0) -> 5218:37:0
// ExpressionStatement#640 (5387:37:0) -> 5218:37:0
// Block#641 (5369:70:0) -> 5200:70:0
// ForStatement#642 (5321:118:0) -> 5152:118:0
// Block#643 (5307:142:0) -> 5138:142:0
// ForStatement#644 (5263:186:0) -> 5094:186:0
// Block#645 (5253:202:0) -> 5084:202:0
// FunctionDefinition#646 (5191:264:0) -> 5022:264:0
// ContractDefinition#647 (4630:827:0) -> 4461:827:0
// ParameterList#648 (5502:2:0) -> 5333:2:0
// ElementaryTypeName#649 (5528:15:0) -> 5359:15:0
// VariableDeclaration#650 (5528:15:0) -> 5359:15:0
// ParameterList#651 (5527:17:0) -> 5358:17:0
// FunctionDefinition#652 (5489:56:0) -> 5320:56:0
// ContractDefinition#653 (5459:88:0) -> 5290:88:0
// UserDefinedTypeName#654 (5579:13:0) -> 5410:13:0
// InheritanceSpecifier#655 (5579:13:0) -> 5410:13:0
// StructuredDocumentation#656 (5599:60:0) -> 5430:64:0
// ElementaryTypeName#657 (5664:15:0) -> 5494:15:0
// OverrideSpecifier#658 (5697:8:0) -> 5527:8:0
// ElementaryTypeName#659 (5713:7:0) -> 5543:7:0
// ElementaryTypeNameExpression#660 (5713:7:0) -> 5543:7:0
// Literal#661 (5721:3:0) -> 5551:3:0
// FunctionCall#662 (5713:12:0) -> 5543:12:0
// VariableDeclaration#663 (5664:61:0) -> 5494:61:0
// ContractDefinition#664 (5549:179:0) -> 5380:178:0
// SourceUnit#665 (168:5561:0) -> 0:5558:0

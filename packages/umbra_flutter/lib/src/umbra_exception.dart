/// {@template umbra_exception}
/// Exception thrown when an error occurs during shader compilation.
/// {@endtemplate}
abstract class UmbraException implements Exception {
  /// {@macro umbra_exception}
  factory UmbraException(Exception exception) {
    final stringifiedException = exception.toString();
    final opCode = int.tryParse(stringifiedException.split(':')[0].trim());
    if (opCode != null) {
      final message = stringifiedException.split(':')[1].trim();
      if (message == 'Not a supported op.') {
        return UnsupportedOperator._(opCode);
      }
      throw Exception('Unknown transpiler exception message: $message');
    }
    throw Exception('Unsupported exception type: $stringifiedException');
  }

  /// {@macro umbra_exception}
  const UmbraException._(this.op);

  /// The opcode of the operator.
  final int op;

  /// The description of the operator.
  String get description;
}

/// {@macro umbra_exception}
///
/// {@template unsupported_operator}
/// Thrown when the shader contains an unsupported operator.
/// {@endtemplate}
class UnsupportedOperator extends UmbraException {
  /// {@macro unsupported_operator}
  const UnsupportedOperator._(super.op) : super._();

  /// The description of the unsupported operator.
  @override
  String get description => _opCodeMap[op] ?? 'unknown';

  @override
  String toString() {
    return '''
Unsupported operator($op): $description

That means that there is an unsupported operator in the shader code.

For more information about this operator see https://www.khronos.org/registry/SPIR-V/specs/unified1/SPIRV.html#$description''';
  }
}

/// Values from https://www.khronos.org/registry/SPIR-V/specs/unified1/SPIRV.html#_instructions_3
const _opCodeMap = {
  0: 'OpNop',
  1: 'OpUndef',
  2: 'OpSourceContinued',
  10: 'OpExtension',
  26: 'OpTypeSampler',
  28: 'OpTypeArray',
  29: 'OpTypeRuntimeArray',
  30: 'OpTypeStruct',
  31: 'OpTypeOpaque',
  34: 'OpTypeEvent',
  35: 'OpTypeDeviceEvent',
  36: 'OpTypeReserveId',
  37: 'OpTypeQueue',
  38: 'OpTypePipe',
  39: 'OpTypeForwardPointer',
  45: 'OpConstantSampler',
  46: 'OpConstantNull',
  48: 'OpSpecConstantTrue',
  49: 'OpSpecConstantFalse',
  50: 'OpSpecConstant',
  51: 'OpSpecConstantComposite',
  52: 'OpSpecConstantOp',
  60: 'OpImageTexelPointer',
  63: 'OpCopyMemory',
  64: 'OpCopyMemorySized',
  66: 'OpInBoundsAccessChain',
  67: 'OpPtrAccessChain',
  68: 'OpArrayLength',
  69: 'OpGenericPtrMemSemantics',
  70: 'OpInBoundsPtrAccessChain',
  72: 'OpMemberDecorate',
  73: 'OpDecorationGroup',
  74: 'OpGroupDecorate',
  75: 'OpGroupMemberDecorate',
  77: 'OpVectorExtractDynamic',
  78: 'OpVectorInsertDynamic',
  82: 'OpCompositeInsert',
  83: 'OpCopyObject',
  84: 'OpTranspose',
  86: 'OpSampledImage',
  88: 'OpImageSampleExplicitLod',
  89: 'OpImageSampleDrefImplicitLod',
  90: 'OpImageSampleDrefExplicitLod',
  91: 'OpImageSampleProjImplicitLod',
  92: 'OpImageSampleProjExplicitLod',
  93: 'OpImageSampleProjDrefImplicitLod',
  94: 'OpImageSampleProjDrefExplicitLod',
  95: 'OpImageFetch',
  96: 'OpImageGather',
  97: 'OpImageDrefGather',
  98: 'OpImageRead',
  99: 'OpImageWrite',
  100: 'OpImage',
  101: 'OpImageQueryFormat',
  102: 'OpImageQueryOrder',
  103: 'OpImageQuerySizeLod',
  105: 'OpImageQueryLod',
  106: 'OpImageQueryLevels',
  107: 'OpImageQuerySamples',
  109: 'OpConvertFToU',
  112: 'OpConvertUToF',
  113: 'OpUConvert',
  114: 'OpSConvert',
  115: 'OpFConvert',
  116: 'OpQuantizeToF16',
  117: 'OpConvertPtrToU',
  118: 'OpSatConvertSToU',
  119: 'OpSatConvertUToS',
  120: 'OpConvertUToPtr',
  121: 'OpPtrCastToGeneric',
  122: 'OpGenericCastToPtr',
  123: 'OpGenericCastToPtrExplicit',
  124: 'OpBitcast',
  126: 'OpSNegate',
  128: 'OpIAdd',
  130: 'OpISub',
  132: 'OpIMul',
  134: 'OpUDiv',
  135: 'OpSDiv',
  137: 'OpUMod',
  138: 'OpSRem',
  139: 'OpSMod',
  140: 'OpFRem',
  147: 'OpOuterProduct',
  149: 'OpIAddCarry',
  150: 'OpISubBorrow',
  151: 'OpUMulExtended',
  152: 'OpSMulExtended',
  154: 'OpAny',
  155: 'OpAll',
  156: 'OpIsNan',
  157: 'OpIsInf',
  158: 'OpIsFinite',
  159: 'OpIsNormal',
  160: 'OpSignBitSet',
  161: 'OpLessOrGreater',
  162: 'OpOrdered',
  163: 'OpUnordered',
  170: 'OpIEqual',
  171: 'OpINotEqual',
  172: 'OpUGreaterThan',
  173: 'OpSGreaterThan',
  174: 'OpUGreaterThanEqual',
  175: 'OpSGreaterThanEqual',
  176: 'OpULessThan',
  177: 'OpSLessThan',
  178: 'OpULessThanEqual',
  179: 'OpSLessThanEqual',
  181: 'OpFUnordEqual',
  182: 'OpFOrdNotEqual',
  185: 'OpFUnordLessThan',
  187: 'OpFUnordGreaterThan',
  189: 'OpFUnordLessThanEqual',
  191: 'OpFUnordGreaterThanEqual',
  194: 'OpShiftRightLogical',
  195: 'OpShiftRightArithmetic',
  196: 'OpShiftLeftLogical',
  197: 'OpBitwiseOr',
  198: 'OpBitwiseXor',
  199: 'OpBitwiseAnd',
  200: 'OpNot',
  201: 'OpBitFieldInsert',
  202: 'OpBitFieldSExtract',
  203: 'OpBitFieldUExtract',
  204: 'OpBitReverse',
  205: 'OpBitCount',
  207: 'OpDPdx',
  208: 'OpDPdy',
  209: 'OpFwidth',
  210: 'OpDPdxFine',
  211: 'OpDPdyFine',
  212: 'OpFwidthFine',
  213: 'OpDPdxCoarse',
  214: 'OpDPdyCoarse',
  215: 'OpFwidthCoarse',
  218: 'OpEmitVertex',
  219: 'OpEndPrimitive',
  220: 'OpEmitStreamVertex',
  221: 'OpEndStreamPrimitive',
  224: 'OpControlBarrier',
  225: 'OpMemoryBarrier',
  227: 'OpAtomicLoad',
  228: 'OpAtomicStore',
  229: 'OpAtomicExchange',
  230: 'OpAtomicCompareExchange',
  231: 'OpAtomicCompareExchangeWeak',
  232: 'OpAtomicIIncrement',
  233: 'OpAtomicIDecrement',
  234: 'OpAtomicIAdd',
  235: 'OpAtomicISub',
  236: 'OpAtomicSMin',
  237: 'OpAtomicUMin',
  238: 'OpAtomicSMax',
  239: 'OpAtomicUMax',
  240: 'OpAtomicAnd',
  241: 'OpAtomicOr',
  242: 'OpAtomicXor',
  245: 'OpPhi',
  251: 'OpSwitch',
  252: 'OpKill',
};

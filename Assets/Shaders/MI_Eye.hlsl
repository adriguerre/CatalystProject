#define NUM_TEX_COORD_INTERPOLATORS 1
#define NUM_MATERIAL_TEXCOORDS_VERTEX 1
#define NUM_CUSTOM_VERTEX_INTERPOLATORS 0

struct Input
{
	//float3 Normal;
	float2 uv_MainTex : TEXCOORD0;
	float2 uv2_Material_Texture2D_0 : TEXCOORD1;
	float4 color : COLOR;
	float4 tangent;
	//float4 normal;
	float3 viewDir;
	float4 screenPos;
	float3 worldPos;
	//float3 worldNormal;
	float3 normal2;
};
struct SurfaceOutputStandard
{
	float3 Albedo;		// base (diffuse or specular) color
	float3 Normal;		// tangent space normal, if written
	half3 Emission;
	half Metallic;		// 0=non-metal, 1=metal
	// Smoothness is the user facing name, it should be perceptual smoothness but user should not have to deal with it.
	// Everywhere in the code you meet smoothness it is perceptual smoothness
	half Smoothness;	// 0=rough, 1=smooth
	half Occlusion;		// occlusion (default 1)
	float Alpha;		// alpha for transparencies
};

//#define HDRP 1
#define URP 1
#define UE5
//#define HAS_CUSTOMIZED_UVS 1
#define MATERIAL_TANGENTSPACENORMAL 1
//struct Material
//{
	//samplers start
SAMPLER( SamplerState_Linear_Repeat );
SAMPLER( SamplerState_Linear_Clamp );
TEXTURE2D(       Material_Texture2D_0 );
SAMPLER( sampler_Material_Texture2D_0 );
TEXTURE2D(       Material_Texture2D_1 );
SAMPLER( sampler_Material_Texture2D_1 );
TEXTURE2D(       Material_Texture2D_2 );
SAMPLER( sampler_Material_Texture2D_2 );
TEXTURE2D(       Material_Texture2D_3 );
SAMPLER( sampler_Material_Texture2D_3 );

//};

#ifdef UE5
	#define UE_LWC_RENDER_TILE_SIZE			2097152.0
	#define UE_LWC_RENDER_TILE_SIZE_SQRT	1448.15466
	#define UE_LWC_RENDER_TILE_SIZE_RSQRT	0.000690533954
	#define UE_LWC_RENDER_TILE_SIZE_RCP		4.76837158e-07
	#define UE_LWC_RENDER_TILE_SIZE_FMOD_PI		0.673652053
	#define UE_LWC_RENDER_TILE_SIZE_FMOD_2PI	0.673652053
	#define INVARIANT(X) X
	#define PI 					(3.1415926535897932)

	#include "LargeWorldCoordinates.hlsl"
#endif
struct MaterialStruct
{
	float4 PreshaderBuffer[10];
	float4 ScalarExpressions[1];
	float VTPackedPageTableUniform[2];
	float VTPackedUniform[1];
};
static SamplerState View_MaterialTextureBilinearWrapedSampler;
static SamplerState View_MaterialTextureBilinearClampedSampler;
struct ViewStruct
{
	float GameTime;
	float RealTime;
	float DeltaTime;
	float PrevFrameGameTime;
	float PrevFrameRealTime;
	float MaterialTextureMipBias;	
	float4 PrimitiveSceneData[ 40 ];
	float4 TemporalAAParams;
	float2 ViewRectMin;
	float4 ViewSizeAndInvSize;
	float MaterialTextureDerivativeMultiply;
	uint StateFrameIndexMod8;
	float FrameNumber;
	float2 FieldOfViewWideAngles;
	float4 RuntimeVirtualTextureMipLevel;
	float PreExposure;
	float4 BufferBilinearUVMinMax;
};
struct ResolvedViewStruct
{
	#ifdef UE5
		FLWCVector3 WorldCameraOrigin;
		FLWCVector3 PrevWorldCameraOrigin;
		FLWCVector3 PreViewTranslation;
		FLWCVector3 WorldViewOrigin;
	#else
		float3 WorldCameraOrigin;
		float3 PrevWorldCameraOrigin;
		float3 PreViewTranslation;
		float3 WorldViewOrigin;
	#endif
	float4 ScreenPositionScaleBias;
	float4x4 TranslatedWorldToView;
	float4x4 TranslatedWorldToCameraView;
	float4x4 TranslatedWorldToClip;
	float4x4 ViewToTranslatedWorld;
	float4x4 PrevViewToTranslatedWorld;
	float4x4 CameraViewToTranslatedWorld;
	float4 BufferBilinearUVMinMax;
	float4 XRPassthroughCameraUVs[ 2 ];
};
struct PrimitiveStruct
{
	float4x4 WorldToLocal;
	float4x4 LocalToWorld;
};

static ViewStruct View;
static ResolvedViewStruct ResolvedView;
static PrimitiveStruct Primitive;
uniform float4 View_BufferSizeAndInvSize;
uniform float4 LocalObjectBoundsMin;
uniform float4 LocalObjectBoundsMax;
static SamplerState Material_Wrap_WorldGroupSettings;
static SamplerState Material_Clamp_WorldGroupSettings;

#include "UnrealCommon.cginc"

static MaterialStruct Material;
void InitializeExpressions()
{
	Material.PreshaderBuffer[0] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[1] = float4(0.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[2] = float4(0.923810,1.082474,0.541237,0.900000);//(Unknown)
	Material.PreshaderBuffer[3] = float4(1.200000,0.000000,0.150000,0.300000);//(Unknown)
	Material.PreshaderBuffer[4] = float4(1.336000,0.138572,0.638572,0.000000);//(Unknown)
	Material.PreshaderBuffer[5] = float4(0.638572,0.500000,1.200000,0.000000);//(Unknown)
	Material.PreshaderBuffer[6] = float4(-0.150000,0.150000,0.045000,0.035000);//(Unknown)
	Material.PreshaderBuffer[7] = float4(0.035000,0.045000,3.333333,0.776190);//(Unknown)
	Material.PreshaderBuffer[8] = float4(0.000000,0.500000,1.500000,2.000000);//(Unknown)
	Material.PreshaderBuffer[9] = float4(0.200000,0.400000,0.070000,0.000000);//(Unknown)
}
MaterialFloat3 CustomExpression2(FMaterialPixelParameters Parameters,MaterialFloat3 HSV)
{
float s = HSV.y;
float v = HSV.z;

float4 K = float4(1.0, 2.0/3.0, 1.0/3.0, 3.0);
float3 p = abs(frac(HSV.xxx + K.xyz) * 6.0 - K.www);

return v * lerp(K.xxx, clamp(p - K.xxx, 0.0, 1.0), s);
}

MaterialFloat2 CustomExpression1(FMaterialPixelParameters Parameters,MaterialFloat2 LimbusUVWidth,MaterialFloat2 UV,MaterialFloat IrisUVRadius)
{
UV = UV - float2(0.5f, 0.5f);

float2 m,r;
r = (length(UV) - (IrisUVRadius - LimbusUVWidth)) / LimbusUVWidth;
m = saturate(1 - r);
m = smoothstep(0, 1, m);
return m;
}

MaterialFloat3 CustomExpression0(FMaterialPixelParameters Parameters,MaterialFloat3 NormalDir,MaterialFloat3 InRayDirFlipped,MaterialFloat MatIoR)
{
float airIoR = 1.00029;

float n = airIoR / MatIoR;

float cosTheta1 = dot(NormalDir, InRayDirFlipped);

float w = n * cosTheta1;

float cosTheta2 = sqrt(1+(w-n)*(w+n));

float3 refract;

// keep n/l ratio to sin(Theta1-Theta2)/sinTheta2
refract = (w-cosTheta2)*NormalDir - n*InRayDirFlipped;

refract = normalize(refract);

return -refract;
}
float3 GetMaterialWorldPositionOffset(FMaterialVertexParameters Parameters)
{
	return MaterialFloat3(0.00000000,0.00000000,0.00000000);;
}
void CalcPixelMaterialInputs(in out FMaterialPixelParameters Parameters, in out FPixelMaterialInputs PixelMaterialInputs)
{
	//WorldAligned texturing & others use normals & stuff that think Z is up
	Parameters.TangentToWorld[0] = Parameters.TangentToWorld[0].xzy;
	Parameters.TangentToWorld[1] = Parameters.TangentToWorld[1].xzy;
	Parameters.TangentToWorld[2] = Parameters.TangentToWorld[2].xzy;

	float3 WorldNormalCopy = Parameters.WorldNormal;

	// Initial calculations (required for Normal)

	// The Normal is a special case as it might have its own expressions and also be used to calculate other inputs, so perform the assignment here
	PixelMaterialInputs.Normal = MaterialFloat3(0.00000000,0.00000000,1.00000000);


#if TEMPLATE_USES_STRATA
	Parameters.StrataPixelFootprint = StrataGetPixelFootprint(Parameters.WorldPosition_CamRelative, GetRoughnessFromNormalCurvature(Parameters));
	Parameters.SharedLocalBases = StrataInitialiseSharedLocalBases();
	Parameters.StrataTree = GetInitialisedStrataTree();
#if STRATA_USE_FULLYSIMPLIFIED_MATERIAL == 1
	Parameters.SharedLocalBasesFullySimplified = StrataInitialiseSharedLocalBases();
	Parameters.StrataTreeFullySimplified = GetInitialisedStrataTree();
#endif
#endif

	// Note that here MaterialNormal can be in world space or tangent space
	float3 MaterialNormal = GetMaterialNormal(Parameters, PixelMaterialInputs);

#if MATERIAL_TANGENTSPACENORMAL

#if FEATURE_LEVEL >= FEATURE_LEVEL_SM4
	// Mobile will rely on only the final normalize for performance
	MaterialNormal = normalize(MaterialNormal);
#endif

	// normalizing after the tangent space to world space conversion improves quality with sheared bases (UV layout to WS causes shrearing)
	// use full precision normalize to avoid overflows
	Parameters.WorldNormal = TransformTangentNormalToWorld(Parameters.TangentToWorld, MaterialNormal);

#else //MATERIAL_TANGENTSPACENORMAL

	Parameters.WorldNormal = normalize(MaterialNormal);

#endif //MATERIAL_TANGENTSPACENORMAL

#if MATERIAL_TANGENTSPACENORMAL
	// flip the normal for backfaces being rendered with a two-sided material
	Parameters.WorldNormal *= Parameters.TwoSidedSign;
#endif

	Parameters.ReflectionVector = ReflectionAboutCustomWorldNormal(Parameters, Parameters.WorldNormal, false);

#if !PARTICLE_SPRITE_FACTORY
	Parameters.Particle.MotionBlurFade = 1.0f;
#endif // !PARTICLE_SPRITE_FACTORY

	// Now the rest of the inputs
	MaterialFloat3 Local0 = lerp(MaterialFloat3(0.00000000,0.00000000,0.00000000),Material.PreshaderBuffer[1].yzw,Material.PreshaderBuffer[1].x);
	MaterialFloat2 Local1 = Parameters.TexCoords[0].xy;
	MaterialFloat2 Local2 = (DERIV_BASE_VALUE(Local1) * ((MaterialFloat2)Material.PreshaderBuffer[2].y));
	MaterialFloat2 Local3 = (DERIV_BASE_VALUE(Local2) + ((MaterialFloat2)0.50000000));
	MaterialFloat2 Local4 = (DERIV_BASE_VALUE(Local3) - ((MaterialFloat2)Material.PreshaderBuffer[2].z));
	MaterialFloat Local5 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local4), 3);
	MaterialFloat4 Local6 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_0,sampler_Material_Texture2D_0,DERIV_BASE_VALUE(Local4),View.MaterialTextureMipBias));
	MaterialFloat Local7 = MaterialStoreTexSample(Parameters, Local6, 3);
	MaterialFloat3 Local8 = (Local6.rgb * ((MaterialFloat3)Material.PreshaderBuffer[2].w));
	MaterialFloat3 Local9 = lerp(MaterialFloat3(1.00000000,1.00000000,1.00000000),Local8,Material.PreshaderBuffer[3].x);
	MaterialFloat3 Local10 = mul(MaterialFloat3(1.00000000,0.00000000,0.00000000), Parameters.TangentToWorld);
	MaterialFloat3 Local11 = normalize(Local10);
	MaterialFloat Local12 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local1), 0);
	MaterialFloat4 Local13 = UnpackNormalMap(Texture2DSampleBias(Material_Texture2D_1,sampler_Material_Texture2D_1,DERIV_BASE_VALUE(Local1),View.MaterialTextureMipBias));
	MaterialFloat Local14 = MaterialStoreTexSample(Parameters, Local13, 0);
	MaterialFloat3 Local15 = mul(Local13.rgb, Parameters.TangentToWorld);
	MaterialFloat Local16 = dot(DERIV_BASE_VALUE(Local11),Local15);
	MaterialFloat3 Local17 = (((MaterialFloat3)Local16) * Local15);
	MaterialFloat3 Local18 = (DERIV_BASE_VALUE(Local11) - Local17);
	MaterialFloat3 Local19 = normalize(Local18);
	MaterialFloat3 Local20 = CustomExpression0(Parameters,WorldNormalCopy,Parameters.CameraVector,Material.PreshaderBuffer[4].x);
	MaterialFloat Local21 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local1), 1);
	MaterialFloat4 Local22 = ProcessMaterialLinearColorTextureLookup(Texture2DSampleBias(Material_Texture2D_2,sampler_Material_Texture2D_2,DERIV_BASE_VALUE(Local1),View.MaterialTextureMipBias));
	MaterialFloat Local23 = MaterialStoreTexSample(Parameters, Local22, 1);
	MaterialFloat Local24 = MaterialStoreTexCoordScale(Parameters, Material.PreshaderBuffer[5].xy, 1);
	MaterialFloat4 Local25 = ProcessMaterialLinearColorTextureLookup(Texture2DSampleBias(Material_Texture2D_2,sampler_Material_Texture2D_2,Material.PreshaderBuffer[5].xy,View.MaterialTextureMipBias));
	MaterialFloat Local26 = MaterialStoreTexSample(Parameters, Local25, 1);
	MaterialFloat3 Local27 = (Local22.rgb - ((MaterialFloat3)Local25.r));
	MaterialFloat3 Local28 = max(Local27,((MaterialFloat3)0.00000000));
	MaterialFloat3 Local29 = (Local28 * ((MaterialFloat3)Material.PreshaderBuffer[5].z));
	MaterialFloat Local30 = dot(Parameters.CameraVector,Local15);
	MaterialFloat Local31 = (Local30 * Local30);
	MaterialFloat Local32 = lerp(0.32499999,1.00000000,Local31);
	MaterialFloat3 Local33 = (Local29 / ((MaterialFloat3)Local32));
	MaterialFloat3 Local34 = (Local20 * Local33);
	MaterialFloat Local35 = dot(Local19,Local34);
	MaterialFloat3 Local36 = cross(Local19,Local15);
	MaterialFloat Local37 = dot(Local36,Local34);
	MaterialFloat2 Local38 = (Material.PreshaderBuffer[6].xy * MaterialFloat2(Local35,Local37));
	MaterialFloat2 Local39 = (DERIV_BASE_VALUE(Local4) + Local38);
	MaterialFloat2 Local40 = CustomExpression1(Parameters,Material.PreshaderBuffer[7].xy,DERIV_BASE_VALUE(Local4),Material.PreshaderBuffer[3].z);
	MaterialFloat2 Local41 = lerp(DERIV_BASE_VALUE(Local4),Local39,Local40.r);
	MaterialFloat2 Local42 = (Local41 - ((MaterialFloat2)0.50000000));
	MaterialFloat2 Local43 = (((MaterialFloat2)Material.PreshaderBuffer[7].z) * Local42);
	MaterialFloat2 Local44 = (Local43 + ((MaterialFloat2)0.50000000));
	MaterialFloat2 Local45 = (Local44 - ((MaterialFloat2)0.50000000));
	MaterialFloat2 Local46 = normalize(Local45);
	MaterialFloat2 Local47 = (Local46 * ((MaterialFloat2)0.50000000));
	MaterialFloat2 Local48 = (Local45 - ((MaterialFloat2)0.00000000));
	MaterialFloat Local49 = length(Local48);
	MaterialFloat Local50 = (Local49 * 2.00000000);
	MaterialFloat Local51 = (1.00000000 - Local50);
	MaterialFloat Local52 = (View.GameTime * 0.20000000);
	MaterialFloat Local53 = (Local52 * 6.28318548);
	MaterialFloat Local54 = sin(Local53);
	MaterialFloat Local55 = (DERIV_BASE_VALUE(Local54) * 0.01000000);
	MaterialFloat Local56 = (Material.PreshaderBuffer[7].w + DERIV_BASE_VALUE(Local55));
	MaterialFloat Local57 = (Local51 * DERIV_BASE_VALUE(Local56));
	MaterialFloat Local58 = saturate(Local57);
	MaterialFloat2 Local59 = lerp(Local47,((MaterialFloat2)0.00000000),Local58);
	MaterialFloat2 Local60 = (Local59 + ((MaterialFloat2)0.50000000));
	MaterialFloat Local61 = MaterialStoreTexCoordScale(Parameters, Local60, 2);
	MaterialFloat4 Local62 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_3,sampler_Material_Texture2D_3,Local60,View.MaterialTextureMipBias));
	MaterialFloat Local63 = MaterialStoreTexSample(Parameters, Local62, 2);
	MaterialFloat Local64 = max(Local62.rgb.r,Local62.rgb.g);
	MaterialFloat Local65 = max(Local64,Local62.rgb.b);
	MaterialFloat Local66 = min(Local62.rgb.r,Local62.rgb.g);
	MaterialFloat Local67 = min(Local66,Local62.rgb.b);
	MaterialFloat Local68 = (Local65 - Local67);
	MaterialFloat3 Local69 = (((MaterialFloat3)Local65) - Local62.rgb);
	MaterialFloat3 Local70 = (Local69 / ((MaterialFloat3)6.00000000));
	MaterialFloat Local71 = (Local68 / 2.00000000);
	MaterialFloat3 Local72 = (Local70 + ((MaterialFloat3)Local71));
	MaterialFloat3 Local73 = (Local72 / ((MaterialFloat3)Local68));
	MaterialFloat Local74 = (0.66666698 + Local73.g);
	MaterialFloat Local75 = (Local74 - Local73.r);
	MaterialFloat Local76 = select((abs(Local62.rgb.b - Local65) > 0.00001000), select((Local62.rgb.b >= Local65), 0.00000000, 0.00000000), Local75);
	MaterialFloat Local77 = (0.33333299 + Local73.r);
	MaterialFloat Local78 = (Local77 - Local73.b);
	MaterialFloat Local79 = select((abs(Local62.rgb.g - Local65) > 0.00001000), select((Local62.rgb.g >= Local65), Local76, Local76), Local78);
	MaterialFloat Local80 = (Local73.b - Local73.g);
	MaterialFloat Local81 = select((abs(Local65 - Local62.rgb.r) > 0.00001000), select((Local65 >= Local62.rgb.r), Local79, Local79), Local80);
	MaterialFloat Local82 = select((abs(Local81 - 0.00000000) > 0.00001000), select((Local81 >= 0.00000000), 0.00000000, 1.00000000), 0.00000000);
	MaterialFloat Local83 = (Local81 + Local82);
	MaterialFloat Local84 = select((abs(Local83 - 1.00000000) > 0.00001000), select((Local83 >= 1.00000000), -1.00000000, 0.00000000), 0.00000000);
	MaterialFloat Local85 = (Local84 + Local83);
	MaterialFloat Local86 = select((abs(Local68 - 0.00000000) > 0.00001000), select((Local68 >= 0.00000000), Local85, Local85), 0.00000000);
	MaterialFloat Local87 = (Local68 / Local65);
	MaterialFloat Local88 = select((abs(Local68 - 0.00000000) > 0.00001000), select((Local68 >= 0.00000000), Local87, Local87), 0.00000000);
	MaterialFloat Local89 = (Material.PreshaderBuffer[8].x + MaterialFloat3(MaterialFloat2(Local86,Local88),Local65).r);
	MaterialFloat Local90 = frac(Local89);
	MaterialFloat Local91 = (MaterialFloat3(MaterialFloat2(Local86,Local88),Local65).g + 0.20000000);
	MaterialFloat Local92 = saturate(Local91);
	MaterialFloat3 Local93 = CustomExpression2(Parameters,MaterialFloat3(MaterialFloat2(Local90,Local92),MaterialFloat3(MaterialFloat2(Local86,Local88),Local65).b));
	MaterialFloat3 Local94 = (Local93 * ((MaterialFloat3)Material.PreshaderBuffer[8].y));
	MaterialFloat2 Local95 = (Local60 + ((MaterialFloat2)-0.50000000));
	MaterialFloat2 Local96 = (Local95 * ((MaterialFloat2)Material.PreshaderBuffer[8].z));
	MaterialFloat2 Local97 = (Local96 - ((MaterialFloat2)0.00000000));
	MaterialFloat Local98 = length(Local97);
	MaterialFloat Local99 = PositiveClampedPow(Local98,Material.PreshaderBuffer[8].w);
	MaterialFloat Local100 = (1.00000000 - Local99);
	MaterialFloat3 Local101 = (Local94 * ((MaterialFloat3)Local100));
	MaterialFloat3 Local102 = lerp(Local9,Local101,Local40.r);
	MaterialFloat Local103 = lerp(Material.PreshaderBuffer[9].y,Material.PreshaderBuffer[9].x,Local40.r);

	PixelMaterialInputs.EmissiveColor = Local0;
	PixelMaterialInputs.Opacity = 1.00000000;
	PixelMaterialInputs.OpacityMask = 1.00000000;
	PixelMaterialInputs.BaseColor = Local102;
	PixelMaterialInputs.Metallic = 0.00000000;
	PixelMaterialInputs.Specular = Local103;
	PixelMaterialInputs.Roughness = Material.PreshaderBuffer[9].z;
	PixelMaterialInputs.Anisotropy = 0.00000000;
	PixelMaterialInputs.Normal = MaterialFloat3(0.00000000,0.00000000,1.00000000);
	PixelMaterialInputs.Tangent = MaterialFloat3(1.00000000,0.00000000,0.00000000);
	PixelMaterialInputs.Subsurface = 0;
	PixelMaterialInputs.AmbientOcclusion = 1.00000000;
	PixelMaterialInputs.Refraction = 0;
	PixelMaterialInputs.PixelDepthOffset = 0.00000000;
	PixelMaterialInputs.ShadingModel = 1;
	PixelMaterialInputs.FrontMaterial = GetInitialisedStrataData();
	PixelMaterialInputs.SurfaceThickness = 0.01000000;
	PixelMaterialInputs.Displacement = 0.00000000;


#if MATERIAL_USES_ANISOTROPY
	Parameters.WorldTangent = CalculateAnisotropyTangent(Parameters, PixelMaterialInputs);
#else
	Parameters.WorldTangent = 0;
#endif
}

#define UnityObjectToWorldDir TransformObjectToWorld

void SetupCommonData( int Parameters_PrimitiveId )
{
	View_MaterialTextureBilinearWrapedSampler = SamplerState_Linear_Repeat;
	View_MaterialTextureBilinearClampedSampler = SamplerState_Linear_Clamp;

	Material_Wrap_WorldGroupSettings = SamplerState_Linear_Repeat;
	Material_Clamp_WorldGroupSettings = SamplerState_Linear_Clamp;

	View.GameTime = View.RealTime = _Time.y;// _Time is (t/20, t, t*2, t*3)
	View.PrevFrameGameTime = View.GameTime - unity_DeltaTime.x;//(dt, 1/dt, smoothDt, 1/smoothDt)
	View.PrevFrameRealTime = View.RealTime;
	View.DeltaTime = unity_DeltaTime.x;
	View.MaterialTextureMipBias = 0.0;
	View.TemporalAAParams = float4( 0, 0, 0, 0 );
	View.ViewRectMin = float2( 0, 0 );
	View.ViewSizeAndInvSize = View_BufferSizeAndInvSize;
	View.MaterialTextureDerivativeMultiply = 1.0f;
	View.StateFrameIndexMod8 = 0;
	View.FrameNumber = (int)_Time.y;
	View.FieldOfViewWideAngles = float2( PI * 0.42f, PI * 0.42f );//75degrees, default unity
	View.RuntimeVirtualTextureMipLevel = float4( 0, 0, 0, 0 );
	View.PreExposure = 0;
	View.BufferBilinearUVMinMax = float4(
		View_BufferSizeAndInvSize.z * ( 0 + 0.5 ),//EffectiveViewRect.Min.X
		View_BufferSizeAndInvSize.w * ( 0 + 0.5 ),//EffectiveViewRect.Min.Y
		View_BufferSizeAndInvSize.z * ( View_BufferSizeAndInvSize.x - 0.5 ),//EffectiveViewRect.Max.X
		View_BufferSizeAndInvSize.w * ( View_BufferSizeAndInvSize.y - 0.5 ) );//EffectiveViewRect.Max.Y

	for( int i2 = 0; i2 < 40; i2++ )
		View.PrimitiveSceneData[ i2 ] = float4( 0, 0, 0, 0 );

	float4x4 LocalToWorld = transpose( UNITY_MATRIX_M );
	float4x4 WorldToLocal = transpose( UNITY_MATRIX_I_M );
	float4x4 ViewMatrix = transpose( UNITY_MATRIX_V );
	float4x4 InverseViewMatrix = transpose( UNITY_MATRIX_I_V );
	float4x4 ViewProjectionMatrix = transpose( UNITY_MATRIX_VP );
	uint PrimitiveBaseOffset = Parameters_PrimitiveId * PRIMITIVE_SCENE_DATA_STRIDE;
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 0 ] = LocalToWorld[ 0 ];//LocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 1 ] = LocalToWorld[ 1 ];//LocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 2 ] = LocalToWorld[ 2 ];//LocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 3 ] = LocalToWorld[ 3 ];//LocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 5 ] = float4( ToUnrealPos( SHADERGRAPH_OBJECT_POSITION ), 100.0 );//ObjectWorldPosition
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 6 ] = WorldToLocal[ 0 ];//WorldToLocal
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 7 ] = WorldToLocal[ 1 ];//WorldToLocal
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 8 ] = WorldToLocal[ 2 ];//WorldToLocal
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 9 ] = WorldToLocal[ 3 ];//WorldToLocal
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 10 ] = LocalToWorld[ 0 ];//PreviousLocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 11 ] = LocalToWorld[ 1 ];//PreviousLocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 12 ] = LocalToWorld[ 2 ];//PreviousLocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 13 ] = LocalToWorld[ 3 ];//PreviousLocalToWorld
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 18 ] = float4( ToUnrealPos( SHADERGRAPH_OBJECT_POSITION ), 0 );//ActorWorldPosition
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 19 ] = LocalObjectBoundsMax - LocalObjectBoundsMin;//ObjectBounds
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 21 ] = mul( LocalToWorld, float3( 1, 0, 0 ) );
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 23 ] = LocalObjectBoundsMin;//LocalObjectBoundsMin 
	View.PrimitiveSceneData[ PrimitiveBaseOffset + 24 ] = LocalObjectBoundsMax;//LocalObjectBoundsMax

#ifdef UE5
	ResolvedView.WorldCameraOrigin = LWCPromote( ToUnrealPos( _WorldSpaceCameraPos.xyz ) );
	ResolvedView.PreViewTranslation = LWCPromote( float3( 0, 0, 0 ) );
	ResolvedView.WorldViewOrigin = LWCPromote( float3( 0, 0, 0 ) );
#else
	ResolvedView.WorldCameraOrigin = ToUnrealPos( _WorldSpaceCameraPos.xyz );
	ResolvedView.PreViewTranslation = float3( 0, 0, 0 );
	ResolvedView.WorldViewOrigin = float3( 0, 0, 0 );
#endif
	ResolvedView.PrevWorldCameraOrigin = ResolvedView.WorldCameraOrigin;
	ResolvedView.ScreenPositionScaleBias = float4( 1, 1, 0, 0 );
	ResolvedView.TranslatedWorldToView		 = ViewMatrix;
	ResolvedView.TranslatedWorldToCameraView = ViewMatrix;
	ResolvedView.TranslatedWorldToClip		 = ViewProjectionMatrix;
	ResolvedView.ViewToTranslatedWorld		 = InverseViewMatrix;
	ResolvedView.PrevViewToTranslatedWorld = ResolvedView.ViewToTranslatedWorld;
	ResolvedView.CameraViewToTranslatedWorld = InverseViewMatrix;
	ResolvedView.BufferBilinearUVMinMax = View.BufferBilinearUVMinMax;
	Primitive.WorldToLocal = WorldToLocal;
	Primitive.LocalToWorld = LocalToWorld;
}
float3 PrepareAndGetWPO( float4 VertexColor, float3 UnrealWorldPos, float3 UnrealNormal, float4 InTangent,
						 float4 UV0, float4 UV1 )
{
	InitializeExpressions();
	FMaterialVertexParameters Parameters = (FMaterialVertexParameters)0;

	float3 InWorldNormal = UnrealNormal;
	float4 tangentWorld = InTangent;
	tangentWorld.xyz = normalize( tangentWorld.xyz );
	//float3x3 tangentToWorld = CreateTangentToWorldPerVertex( InWorldNormal, tangentWorld.xyz, tangentWorld.w );
	Parameters.TangentToWorld = float3x3( normalize( cross( InWorldNormal, tangentWorld.xyz ) * tangentWorld.w ), tangentWorld.xyz, InWorldNormal );

	
	UnrealWorldPos = ToUnrealPos( UnrealWorldPos );
	Parameters.WorldPosition = UnrealWorldPos;
	Parameters.TangentToWorld[ 0 ] = Parameters.TangentToWorld[ 0 ].xzy;
	Parameters.TangentToWorld[ 1 ] = Parameters.TangentToWorld[ 1 ].xzy;
	Parameters.TangentToWorld[ 2 ] = Parameters.TangentToWorld[ 2 ].xzy;//WorldAligned texturing uses normals that think Z is up

	Parameters.VertexColor = VertexColor;

#if NUM_MATERIAL_TEXCOORDS_VERTEX > 0			
	Parameters.TexCoords[ 0 ] = float2( UV0.x, UV0.y );
#endif
#if NUM_MATERIAL_TEXCOORDS_VERTEX > 1
	Parameters.TexCoords[ 1 ] = float2( UV1.x, UV1.y );
#endif
#if NUM_MATERIAL_TEXCOORDS_VERTEX > 2
	for( int i = 2; i < NUM_TEX_COORD_INTERPOLATORS; i++ )
	{
		Parameters.TexCoords[ i ] = float2( UV0.x, UV0.y );
	}
#endif

	Parameters.PrimitiveId = 0;

	SetupCommonData( Parameters.PrimitiveId );

#ifdef UE5
	Parameters.PrevFrameLocalToWorld = MakeLWCMatrix( float3( 0, 0, 0 ), Primitive.LocalToWorld );
#else
	Parameters.PrevFrameLocalToWorld = Primitive.LocalToWorld;
#endif
	
	float3 Offset = float3( 0, 0, 0 );
	Offset = GetMaterialWorldPositionOffset( Parameters );
	//Convert from unreal units to unity
	Offset /= float3( 100, 100, 100 );
	Offset = Offset.xzy;
	return Offset;
}

void SurfaceReplacement( Input In, out SurfaceOutputStandard o )
{
	InitializeExpressions();

	float3 Z3 = float3( 0, 0, 0 );
	float4 Z4 = float4( 0, 0, 0, 0 );

	float3 UnrealWorldPos = float3( In.worldPos.x, In.worldPos.y, In.worldPos.z );

	float3 UnrealNormal = In.normal2;	

	FMaterialPixelParameters Parameters = (FMaterialPixelParameters)0;
#if NUM_TEX_COORD_INTERPOLATORS > 0			
	Parameters.TexCoords[ 0 ] = float2( In.uv_MainTex.x, 1.0 - In.uv_MainTex.y );
#endif
#if NUM_TEX_COORD_INTERPOLATORS > 1
	Parameters.TexCoords[ 1 ] = float2( In.uv2_Material_Texture2D_0.x, 1.0 - In.uv2_Material_Texture2D_0.y );
#endif
#if NUM_TEX_COORD_INTERPOLATORS > 2
	for( int i = 2; i < NUM_TEX_COORD_INTERPOLATORS; i++ )
	{
		Parameters.TexCoords[ i ] = float2( In.uv_MainTex.x, 1.0 - In.uv_MainTex.y );
	}
#endif
	Parameters.VertexColor = In.color;
	Parameters.WorldNormal = UnrealNormal;
	Parameters.ReflectionVector = half3( 0, 0, 1 );
	Parameters.CameraVector = normalize( _WorldSpaceCameraPos.xyz - UnrealWorldPos.xyz );
	//Parameters.CameraVector = mul( ( float3x3 )unity_CameraToWorld, float3( 0, 0, 1 ) ) * -1;
	Parameters.LightVector = half3( 0, 0, 0 );
	//float4 screenpos = In.screenPos;
	//screenpos /= screenpos.w;
	Parameters.SvPosition = In.screenPos;
	Parameters.ScreenPosition = Parameters.SvPosition;

	Parameters.UnMirrored = 1;

	Parameters.TwoSidedSign = 1;


	float3 InWorldNormal = UnrealNormal;	
	float4 tangentWorld = In.tangent;
	tangentWorld.xyz = normalize( tangentWorld.xyz );
	//float3x3 tangentToWorld = CreateTangentToWorldPerVertex( InWorldNormal, tangentWorld.xyz, tangentWorld.w );
	Parameters.TangentToWorld = float3x3( normalize( cross( InWorldNormal, tangentWorld.xyz ) * tangentWorld.w ), tangentWorld.xyz, InWorldNormal );

	//WorldAlignedTexturing in UE relies on the fact that coords there are 100x larger, prepare values for that
	//but watch out for any computation that might get skewed as a side effect
	UnrealWorldPos = ToUnrealPos( UnrealWorldPos );
	
	Parameters.AbsoluteWorldPosition = UnrealWorldPos;
	Parameters.WorldPosition_CamRelative = UnrealWorldPos;
	Parameters.WorldPosition_NoOffsets = UnrealWorldPos;

	Parameters.WorldPosition_NoOffsets_CamRelative = Parameters.WorldPosition_CamRelative;
	Parameters.LightingPositionOffset = float3( 0, 0, 0 );

	Parameters.AOMaterialMask = 0;

	Parameters.Particle.RelativeTime = 0;
	Parameters.Particle.MotionBlurFade;
	Parameters.Particle.Random = 0;
	Parameters.Particle.Velocity = half4( 1, 1, 1, 1 );
	Parameters.Particle.Color = half4( 1, 1, 1, 1 );
	Parameters.Particle.TranslatedWorldPositionAndSize = float4( UnrealWorldPos, 0 );
	Parameters.Particle.MacroUV = half4( 0, 0, 1, 1 );
	Parameters.Particle.DynamicParameter = half4( 0, 0, 0, 0 );
	Parameters.Particle.LocalToWorld = float4x4( Z4, Z4, Z4, Z4 );
	Parameters.Particle.Size = float2( 1, 1 );
	Parameters.Particle.SubUVCoords[ 0 ] = Parameters.Particle.SubUVCoords[ 1 ] = float2( 0, 0 );
	Parameters.Particle.SubUVLerp = 0.0;
	Parameters.TexCoordScalesParams = float2( 0, 0 );
	Parameters.PrimitiveId = 0;
	Parameters.VirtualTextureFeedback = 0;

	FPixelMaterialInputs PixelMaterialInputs = (FPixelMaterialInputs)0;
	PixelMaterialInputs.Normal = float3( 0, 0, 1 );
	PixelMaterialInputs.ShadingModel = 0;
	PixelMaterialInputs.FrontMaterial = 0;

	SetupCommonData( Parameters.PrimitiveId );
	//CustomizedUVs
	#if NUM_TEX_COORD_INTERPOLATORS > 0 && HAS_CUSTOMIZED_UVS
		float2 OutTexCoords[ NUM_TEX_COORD_INTERPOLATORS ];
		GetMaterialCustomizedUVs( Parameters, OutTexCoords );
		for( int i = 0; i < NUM_TEX_COORD_INTERPOLATORS; i++ )
		{
			Parameters.TexCoords[ i ] = OutTexCoords[ i ];
		}
	#endif
	//<-
	CalcPixelMaterialInputs( Parameters, PixelMaterialInputs );

	#define HAS_WORLDSPACE_NORMAL 0
	#if HAS_WORLDSPACE_NORMAL
		PixelMaterialInputs.Normal = mul( PixelMaterialInputs.Normal, (MaterialFloat3x3)( transpose( Parameters.TangentToWorld ) ) );
	#endif

	o.Albedo = PixelMaterialInputs.BaseColor.rgb;
	o.Alpha = PixelMaterialInputs.Opacity;
	//if( PixelMaterialInputs.OpacityMask < 0.333 ) discard;

	o.Metallic = PixelMaterialInputs.Metallic;
	o.Smoothness = 1.0 - PixelMaterialInputs.Roughness;
	o.Normal = normalize( PixelMaterialInputs.Normal );
	o.Emission = PixelMaterialInputs.EmissiveColor.rgb;
	o.Occlusion = PixelMaterialInputs.AmbientOcclusion;

	//BLEND_ADDITIVE o.Alpha = ( o.Emission.r + o.Emission.g + o.Emission.b ) / 3;
}
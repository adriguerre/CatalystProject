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
TEXTURE2D(       Material_Texture2D_4 );
SAMPLER( sampler_Material_Texture2D_4 );
TEXTURE2D(       Material_Texture2D_5 );
SAMPLER( sampler_Material_Texture2D_5 );
TEXTURE2D(       Material_Texture2D_6 );
SAMPLER( sampler_Material_Texture2D_6 );
TEXTURE2D(       Material_Texture2D_7 );
SAMPLER( sampler_Material_Texture2D_7 );
TEXTURE2D(       Material_Texture2D_8 );
SAMPLER( sampler_Material_Texture2D_8 );

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
	float4 PreshaderBuffer[18];
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
	Material.PreshaderBuffer[2] = float4(2.000000,0.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[3] = float4(0.036458,0.036458,0.036458,1.000000);//(Unknown)
	Material.PreshaderBuffer[4] = float4(0.036458,0.036458,0.036458,0.000000);//(Unknown)
	Material.PreshaderBuffer[5] = float4(0.963542,0.963542,0.963542,2.000000);//(Unknown)
	Material.PreshaderBuffer[6] = float4(0.089938,0.085449,0.109375,1.000000);//(Unknown)
	Material.PreshaderBuffer[7] = float4(0.089938,0.085449,0.109375,0.000000);//(Unknown)
	Material.PreshaderBuffer[8] = float4(0.910062,0.914551,0.890625,2.000000);//(Unknown)
	Material.PreshaderBuffer[9] = float4(0.066504,0.064279,0.083333,1.000000);//(Unknown)
	Material.PreshaderBuffer[10] = float4(0.066504,0.064279,0.083333,0.000000);//(Unknown)
	Material.PreshaderBuffer[11] = float4(0.933496,0.935721,0.916667,0.000000);//(Unknown)
	Material.PreshaderBuffer[12] = float4(1.000000,5.000000,0.000000,0.000000);//(Unknown)
	Material.PreshaderBuffer[13] = float4(0.052861,0.051269,0.061246,1.000000);//(Unknown)
	Material.PreshaderBuffer[14] = float4(0.052861,0.051269,0.061246,0.000000);//(Unknown)
	Material.PreshaderBuffer[15] = float4(0.947139,0.948731,0.938754,0.000000);//(Unknown)
	Material.PreshaderBuffer[16] = float4(1.000000,1.000000,1.000000,1.000000);//(Unknown)
	Material.PreshaderBuffer[17] = float4(1.000000,0.000000,0.000000,0.000000);//(Unknown)
}float3 GetMaterialWorldPositionOffset(FMaterialVertexParameters Parameters)
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
	MaterialFloat2 Local0 = Parameters.TexCoords[0].xy;
	MaterialFloat Local1 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local0), 0);
	MaterialFloat4 Local2 = UnpackNormalMap(Texture2DSampleBias(Material_Texture2D_0,sampler_Material_Texture2D_0,DERIV_BASE_VALUE(Local0),View.MaterialTextureMipBias));
	MaterialFloat Local3 = MaterialStoreTexSample(Parameters, Local2, 0);

	// The Normal is a special case as it might have its own expressions and also be used to calculate other inputs, so perform the assignment here
	PixelMaterialInputs.Normal = Local2.rgb;


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
	MaterialFloat Local4 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local0), 1);
	MaterialFloat4 Local5 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_1,sampler_Material_Texture2D_1,DERIV_BASE_VALUE(Local0),View.MaterialTextureMipBias));
	MaterialFloat Local6 = MaterialStoreTexSample(Parameters, Local5, 1);
	MaterialFloat3 Local7 = lerp(Local5.rgb,Material.PreshaderBuffer[1].yzw,Material.PreshaderBuffer[1].x);
	MaterialFloat2 Local8 = (((MaterialFloat2)Material.PreshaderBuffer[2].x) * DERIV_BASE_VALUE(Local0));
	MaterialFloat Local9 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local8), 4);
	MaterialFloat4 Local10 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_2,sampler_Material_Texture2D_2,DERIV_BASE_VALUE(Local8),View.MaterialTextureMipBias));
	MaterialFloat Local11 = MaterialStoreTexSample(Parameters, Local10, 4);
	MaterialFloat3 Local12 = (((MaterialFloat3)1.00000000) - Local10.rgb);
	MaterialFloat3 Local13 = (Local12 * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local14 = (Local13 * Material.PreshaderBuffer[5].xyz);
	MaterialFloat3 Local15 = (((MaterialFloat3)1.00000000) - Local14);
	MaterialFloat3 Local16 = (Local10.rgb * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local17 = (Local16 * Material.PreshaderBuffer[4].xyz);
	MaterialFloat Local18 = select((Local10.rgb.r >= 0.50000000), Local15.r, Local17.r);
	MaterialFloat Local19 = select((Local10.rgb.g >= 0.50000000), Local15.g, Local17.g);
	MaterialFloat Local20 = select((Local10.rgb.b >= 0.50000000), Local15.b, Local17.b);
	MaterialFloat Local21 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local0), 5);
	MaterialFloat4 Local22 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_3,sampler_Material_Texture2D_3,DERIV_BASE_VALUE(Local0),View.MaterialTextureMipBias));
	MaterialFloat Local23 = MaterialStoreTexSample(Parameters, Local22, 5);
	MaterialFloat Local24 = (1.00000000 - Local22.a);
	MaterialFloat3 Local25 = lerp(MaterialFloat3(MaterialFloat2(Local18,Local19),Local20),((MaterialFloat3)0.50000000),Local24);
	MaterialFloat3 Local26 = (((MaterialFloat3)1.00000000) - Local25);
	MaterialFloat3 Local27 = (Local26 * ((MaterialFloat3)2.00000000));
	MaterialFloat2 Local28 = (((MaterialFloat2)Material.PreshaderBuffer[5].w) * DERIV_BASE_VALUE(Local0));
	MaterialFloat Local29 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local28), 4);
	MaterialFloat4 Local30 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_4,sampler_Material_Texture2D_4,DERIV_BASE_VALUE(Local28),View.MaterialTextureMipBias));
	MaterialFloat Local31 = MaterialStoreTexSample(Parameters, Local30, 4);
	MaterialFloat3 Local32 = (((MaterialFloat3)1.00000000) - Local30.rgb);
	MaterialFloat3 Local33 = (Local32 * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local34 = (Local33 * Material.PreshaderBuffer[8].xyz);
	MaterialFloat3 Local35 = (((MaterialFloat3)1.00000000) - Local34);
	MaterialFloat3 Local36 = (Local30.rgb * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local37 = (Local36 * Material.PreshaderBuffer[7].xyz);
	MaterialFloat Local38 = select((Local30.rgb.r >= 0.50000000), Local35.r, Local37.r);
	MaterialFloat Local39 = select((Local30.rgb.g >= 0.50000000), Local35.g, Local37.g);
	MaterialFloat Local40 = select((Local30.rgb.b >= 0.50000000), Local35.b, Local37.b);
	MaterialFloat Local41 = (1.00000000 - Local22.b);
	MaterialFloat3 Local42 = lerp(MaterialFloat3(MaterialFloat2(Local38,Local39),Local40),((MaterialFloat3)0.50000000),Local41);
	MaterialFloat3 Local43 = (((MaterialFloat3)1.00000000) - Local42);
	MaterialFloat3 Local44 = (Local43 * ((MaterialFloat3)2.00000000));
	MaterialFloat2 Local45 = (((MaterialFloat2)Material.PreshaderBuffer[8].w) * DERIV_BASE_VALUE(Local0));
	MaterialFloat Local46 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local45), 4);
	MaterialFloat4 Local47 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_5,sampler_Material_Texture2D_5,DERIV_BASE_VALUE(Local45),View.MaterialTextureMipBias));
	MaterialFloat Local48 = MaterialStoreTexSample(Parameters, Local47, 4);
	MaterialFloat3 Local49 = (((MaterialFloat3)1.00000000) - Local47.rgb);
	MaterialFloat3 Local50 = (Local49 * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local51 = (Local50 * Material.PreshaderBuffer[11].xyz);
	MaterialFloat3 Local52 = (((MaterialFloat3)1.00000000) - Local51);
	MaterialFloat3 Local53 = (Local47.rgb * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local54 = (Local53 * Material.PreshaderBuffer[10].xyz);
	MaterialFloat Local55 = select((Local47.rgb.r >= 0.50000000), Local52.r, Local54.r);
	MaterialFloat Local56 = select((Local47.rgb.g >= 0.50000000), Local52.g, Local54.g);
	MaterialFloat Local57 = select((Local47.rgb.b >= 0.50000000), Local52.b, Local54.b);
	MaterialFloat Local58 = dot(MaterialFloat3(MaterialFloat2(Local55,Local56),Local57),MaterialFloat3(0.30000001,0.58999997,0.11000000));
	MaterialFloat3 Local59 = lerp(MaterialFloat3(MaterialFloat2(Local55,Local56),Local57),((MaterialFloat3)Local58),Material.PreshaderBuffer[11].w);
	MaterialFloat Local60 = (1.00000000 - Local22.g);
	MaterialFloat3 Local61 = lerp(Local59,((MaterialFloat3)0.50000000),Local60);
	MaterialFloat3 Local62 = (((MaterialFloat3)1.00000000) - Local61);
	MaterialFloat3 Local63 = (Local62 * ((MaterialFloat3)2.00000000));
	MaterialFloat4 Local64 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_6,sampler_Material_Texture2D_6,DERIV_BASE_VALUE(Local0),View.MaterialTextureMipBias));
	MaterialFloat Local65 = MaterialStoreTexSample(Parameters, Local64, 5);
	MaterialFloat3 Local66 = PositiveClampedPow(Local64.rgb,((MaterialFloat3)Material.PreshaderBuffer[12].x));
	MaterialFloat3 Local67 = (((MaterialFloat3)1.00000000) - Local66);
	MaterialFloat3 Local68 = (Local67 * ((MaterialFloat3)2.00000000));
	MaterialFloat2 Local69 = (((MaterialFloat2)Material.PreshaderBuffer[12].y) * DERIV_BASE_VALUE(Local0));
	MaterialFloat Local70 = MaterialStoreTexCoordScale(Parameters, DERIV_BASE_VALUE(Local69), 4);
	MaterialFloat4 Local71 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_7,sampler_Material_Texture2D_7,DERIV_BASE_VALUE(Local69),View.MaterialTextureMipBias));
	MaterialFloat Local72 = MaterialStoreTexSample(Parameters, Local71, 4);
	MaterialFloat3 Local73 = (((MaterialFloat3)1.00000000) - Local71.rgb);
	MaterialFloat3 Local74 = (Local73 * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local75 = (Local74 * Material.PreshaderBuffer[15].xyz);
	MaterialFloat3 Local76 = (((MaterialFloat3)1.00000000) - Local75);
	MaterialFloat3 Local77 = (Local71.rgb * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local78 = (Local77 * Material.PreshaderBuffer[14].xyz);
	MaterialFloat Local79 = select((Local71.rgb.r >= 0.50000000), Local76.r, Local78.r);
	MaterialFloat Local80 = select((Local71.rgb.g >= 0.50000000), Local76.g, Local78.g);
	MaterialFloat Local81 = select((Local71.rgb.b >= 0.50000000), Local76.b, Local78.b);
	MaterialFloat Local82 = dot(MaterialFloat3(MaterialFloat2(Local79,Local80),Local81),MaterialFloat3(0.30000001,0.58999997,0.11000000));
	MaterialFloat3 Local83 = lerp(MaterialFloat3(MaterialFloat2(Local79,Local80),Local81),((MaterialFloat3)Local82),Material.PreshaderBuffer[15].w);
	MaterialFloat Local84 = (1.00000000 - Local22.r);
	MaterialFloat3 Local85 = lerp(Local83,((MaterialFloat3)0.50000000),Local84);
	MaterialFloat3 Local86 = (((MaterialFloat3)1.00000000) - Local85);
	MaterialFloat3 Local87 = (Local68 * Local86);
	MaterialFloat3 Local88 = (((MaterialFloat3)1.00000000) - Local87);
	MaterialFloat3 Local89 = (Local66 * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local90 = (Local89 * Local85);
	MaterialFloat Local91 = select((Local66.r >= 0.50000000), Local88.r, Local90.r);
	MaterialFloat Local92 = select((Local66.g >= 0.50000000), Local88.g, Local90.g);
	MaterialFloat Local93 = select((Local66.b >= 0.50000000), Local88.b, Local90.b);
	MaterialFloat3 Local94 = (((MaterialFloat3)1.00000000) - MaterialFloat3(MaterialFloat2(Local91,Local92),Local93));
	MaterialFloat3 Local95 = (Local63 * Local94);
	MaterialFloat3 Local96 = (((MaterialFloat3)1.00000000) - Local95);
	MaterialFloat3 Local97 = (Local61 * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local98 = (Local97 * MaterialFloat3(MaterialFloat2(Local91,Local92),Local93));
	MaterialFloat Local99 = select((Local61.r >= 0.50000000), Local96.r, Local98.r);
	MaterialFloat Local100 = select((Local61.g >= 0.50000000), Local96.g, Local98.g);
	MaterialFloat Local101 = select((Local61.b >= 0.50000000), Local96.b, Local98.b);
	MaterialFloat3 Local102 = (((MaterialFloat3)1.00000000) - MaterialFloat3(MaterialFloat2(Local99,Local100),Local101));
	MaterialFloat3 Local103 = (Local44 * Local102);
	MaterialFloat3 Local104 = (((MaterialFloat3)1.00000000) - Local103);
	MaterialFloat3 Local105 = (Local42 * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local106 = (Local105 * MaterialFloat3(MaterialFloat2(Local99,Local100),Local101));
	MaterialFloat Local107 = select((Local42.r >= 0.50000000), Local104.r, Local106.r);
	MaterialFloat Local108 = select((Local42.g >= 0.50000000), Local104.g, Local106.g);
	MaterialFloat Local109 = select((Local42.b >= 0.50000000), Local104.b, Local106.b);
	MaterialFloat3 Local110 = (((MaterialFloat3)1.00000000) - MaterialFloat3(MaterialFloat2(Local107,Local108),Local109));
	MaterialFloat3 Local111 = (Local27 * Local110);
	MaterialFloat3 Local112 = (((MaterialFloat3)1.00000000) - Local111);
	MaterialFloat3 Local113 = (Local25 * ((MaterialFloat3)2.00000000));
	MaterialFloat3 Local114 = (Local113 * MaterialFloat3(MaterialFloat2(Local107,Local108),Local109));
	MaterialFloat Local115 = select((Local25.r >= 0.50000000), Local112.r, Local114.r);
	MaterialFloat Local116 = select((Local25.g >= 0.50000000), Local112.g, Local114.g);
	MaterialFloat Local117 = select((Local25.b >= 0.50000000), Local112.b, Local114.b);
	MaterialFloat4 Local118 = ProcessMaterialColorTextureLookup(Texture2DSampleBias(Material_Texture2D_8,sampler_Material_Texture2D_8,DERIV_BASE_VALUE(Local0),View.MaterialTextureMipBias));
	MaterialFloat Local119 = MaterialStoreTexSample(Parameters, Local118, 5);
	MaterialFloat Local120 = PositiveClampedPow(Local118.g,Material.PreshaderBuffer[16].x);
	MaterialFloat Local121 = PositiveClampedPow(Local118.g,Material.PreshaderBuffer[16].y);
	MaterialFloat Local122 = PositiveClampedPow(Local118.g,Material.PreshaderBuffer[16].z);
	MaterialFloat Local123 = PositiveClampedPow(Local118.g,Material.PreshaderBuffer[16].w);
	MaterialFloat Local124 = lerp(Local123,Local118.g,Local84);
	MaterialFloat Local125 = lerp(Local122,Local124,Local60);
	MaterialFloat Local126 = lerp(Local121,Local125,Local41);
	MaterialFloat Local127 = lerp(Local120,Local126,Local24);
	MaterialFloat Local128 = PositiveClampedPow(Local118.r,Material.PreshaderBuffer[17].x);

	PixelMaterialInputs.EmissiveColor = Local7;
	PixelMaterialInputs.Opacity = 1.00000000;
	PixelMaterialInputs.OpacityMask = 1.00000000;
	PixelMaterialInputs.BaseColor = MaterialFloat3(MaterialFloat2(Local115,Local116),Local117);
	PixelMaterialInputs.Metallic = Local118.b;
	PixelMaterialInputs.Specular = 0.50000000;
	PixelMaterialInputs.Roughness = Local127;
	PixelMaterialInputs.Anisotropy = 0.00000000;
	PixelMaterialInputs.Normal = Local2.rgb;
	PixelMaterialInputs.Tangent = MaterialFloat3(1.00000000,0.00000000,0.00000000);
	PixelMaterialInputs.Subsurface = 0;
	PixelMaterialInputs.AmbientOcclusion = Local128;
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
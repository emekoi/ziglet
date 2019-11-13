pub const DWORD = c_ulong;
pub const PVOID = ?*c_void;
pub const ULONG_PTR = c_ulonglong;
pub const WORD = c_ushort;
pub const BYTE = u8;
pub const ULONGLONG = c_ulonglong;
pub const LONGLONG = c_longlong;
pub const PULONG = [*c]ULONG;
pub const USHORT = c_ushort;
pub const UCHAR = u8;
pub const BOOL = c_int;
pub const FLOAT = f32;
pub const INT = c_int;
pub const UINT = c_uint;
pub const UINT8 = u8;
pub const SIZE_T = ULONG_PTR;
pub const CHAR = u8;
pub const SHORT = c_short;
pub const LONG = c_long;
pub const WCHAR = c_ushort;
pub const LPCWSTR = [*c]const WCHAR;
pub const LPSTR = [*c]CHAR;
pub const LPCSTR = [*c]const CHAR;
pub const HANDLE = ?*c_void;
pub const HRESULT = LONG;
pub const ULONG = c_ulong;
pub const HMODULE = HINSTANCE;
pub const HINSTANCE = HANDLE;
pub const HWND = HANDLE;
pub const LARGE_INTEGER = extern union {
    _u1: extern struct {
        LowPart: DWORD,
        HighPart: LONG,
    },
    _u2: extern struct {
        LowPart: DWORD,
        HighPart: LONG,
    },
    QuadPart: LONGLONG,
};
pub const GUID = extern struct {
    Data1: c_ulong,
    Data2: c_ushort,
    Data3: c_ushort,
    Data4: [8]u8,
};
pub const IID = GUID;
pub const LUID = extern struct {
    LowPart: DWORD,
    HighPart: LONG,
};
pub const RECT = extern struct {
    left: LONG,
    top: LONG,
    right: LONG,
    bottom: LONG,
};
pub const POINT = extern struct {
    x: LONG,
    y: LONG,
};
pub const D3D11_USAGE = extern enum {
    DEFAULT = 0,
    IMMUTABLE = 1,
    DYNAMIC = 2,
    STAGING = 3,
};
pub const D3D11_BUFFER_DESC = extern struct {
    ByteWidth: UINT,
    Usage: D3D11_USAGE,
    BindFlags: UINT,
    CPUAccessFlags: UINT,
    MiscFlags: UINT,
    StructureByteStride: UINT,
};

pub const D3D11_SUBRESOURCE_DATA = extern struct {
    pSysMem: ?[*]const u8,
    SysMemPitch: UINT,
    SysMemSlicePitch: UINT,
};

pub const D3D11_RESOURCE_DIMENSION = extern enum {
    UNKNOWN = 0,
    BUFFER = 1,
    TEXTURE1D = 2,
    TEXTURE2D = 3,
    TEXTURE3D = 4,
};
pub const ID3D11BufferVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Buffer, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Buffer) ULONG,
    Release: ?extern fn ([*c]ID3D11Buffer) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11Buffer, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11Buffer, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Buffer, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Buffer, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetType: ?extern fn ([*c]ID3D11Buffer, [*c]D3D11_RESOURCE_DIMENSION) void,
    SetEvictionPriority: ?extern fn ([*c]ID3D11Buffer, UINT) void,
    GetEvictionPriority: ?extern fn ([*c]ID3D11Buffer) UINT,
    GetDesc: ?extern fn ([*c]ID3D11Buffer, [*c]D3D11_BUFFER_DESC) void,
};
pub const ID3D11Buffer = extern struct {
    lpVtbl: [*c]ID3D11BufferVtbl,
};
pub const DXGI_FORMAT = extern enum(c_uint) {
    UNKNOWN = 0,
    R32G32B32A32_TYPELESS = 1,
    R32G32B32A32_FLOAT = 2,
    R32G32B32A32_UINT = 3,
    R32G32B32A32_SINT = 4,
    R32G32B32_TYPELESS = 5,
    R32G32B32_FLOAT = 6,
    R32G32B32_UINT = 7,
    R32G32B32_SINT = 8,
    R16G16B16A16_TYPELESS = 9,
    R16G16B16A16_FLOAT = 10,
    R16G16B16A16_UNORM = 11,
    R16G16B16A16_UINT = 12,
    R16G16B16A16_SNORM = 13,
    R16G16B16A16_SINT = 14,
    R32G32_TYPELESS = 15,
    R32G32_FLOAT = 16,
    R32G32_UINT = 17,
    R32G32_SINT = 18,
    R32G8X24_TYPELESS = 19,
    D32_FLOAT_S8X24_UINT = 20,
    R32_FLOAT_X8X24_TYPELESS = 21,
    X32_TYPELESS_G8X24_UINT = 22,
    R10G10B10A2_TYPELESS = 23,
    R10G10B10A2_UNORM = 24,
    R10G10B10A2_UINT = 25,
    R11G11B10_FLOAT = 26,
    R8G8B8A8_TYPELESS = 27,
    R8G8B8A8_UNORM = 28,
    R8G8B8A8_UNORM_SRGB = 29,
    R8G8B8A8_UINT = 30,
    R8G8B8A8_SNORM = 31,
    R8G8B8A8_SINT = 32,
    R16G16_TYPELESS = 33,
    R16G16_FLOAT = 34,
    R16G16_UNORM = 35,
    R16G16_UINT = 36,
    R16G16_SNORM = 37,
    R16G16_SINT = 38,
    R32_TYPELESS = 39,
    D32_FLOAT = 40,
    R32_FLOAT = 41,
    R32_UINT = 42,
    R32_SINT = 43,
    R24G8_TYPELESS = 44,
    D24_UNORM_S8_UINT = 45,
    R24_UNORM_X8_TYPELESS = 46,
    X24_TYPELESS_G8_UINT = 47,
    R8G8_TYPELESS = 48,
    R8G8_UNORM = 49,
    R8G8_UINT = 50,
    R8G8_SNORM = 51,
    R8G8_SINT = 52,
    R16_TYPELESS = 53,
    R16_FLOAT = 54,
    D16_UNORM = 55,
    R16_UNORM = 56,
    R16_UINT = 57,
    R16_SNORM = 58,
    R16_SINT = 59,
    R8_TYPELESS = 60,
    R8_UNORM = 61,
    R8_UINT = 62,
    R8_SNORM = 63,
    R8_SINT = 64,
    A8_UNORM = 65,
    R1_UNORM = 66,
    R9G9B9E5_SHAREDEXP = 67,
    R8G8_B8G8_UNORM = 68,
    G8R8_G8B8_UNORM = 69,
    BC1_TYPELESS = 70,
    BC1_UNORM = 71,
    BC1_UNORM_SRGB = 72,
    BC2_TYPELESS = 73,
    BC2_UNORM = 74,
    BC2_UNORM_SRGB = 75,
    BC3_TYPELESS = 76,
    BC3_UNORM = 77,
    BC3_UNORM_SRGB = 78,
    BC4_TYPELESS = 79,
    BC4_UNORM = 80,
    BC4_SNORM = 81,
    BC5_TYPELESS = 82,
    BC5_UNORM = 83,
    BC5_SNORM = 84,
    B5G6R5_UNORM = 85,
    B5G5R5A1_UNORM = 86,
    B8G8R8A8_UNORM = 87,
    B8G8R8X8_UNORM = 88,
    R10G10B10_XR_BIAS_A2_UNORM = 89,
    B8G8R8A8_TYPELESS = 90,
    B8G8R8A8_UNORM_SRGB = 91,
    B8G8R8X8_TYPELESS = 92,
    B8G8R8X8_UNORM_SRGB = 93,
    BC6H_TYPELESS = 94,
    BC6H_UF16 = 95,
    BC6H_SF16 = 96,
    BC7_TYPELESS = 97,
    BC7_UNORM = 98,
    BC7_UNORM_SRGB = 99,
    AYUV = 100,
    Y410 = 101,
    Y416 = 102,
    NV12 = 103,
    P010 = 104,
    P016 = 105,
    OPAQUE = 106,
    YUY2 = 107,
    Y210 = 108,
    Y216 = 109,
    NV11 = 110,
    AI44 = 111,
    IA44 = 112,
    P8 = 113,
    A8P8 = 114,
    B4G4R4A4_UNORM = 115,
    P208 = 130,
    V208 = 131,
    V408 = 132,
};
pub const D3D11_TEXTURE1D_DESC = extern struct {
    Width: UINT,
    MipLevels: UINT,
    ArraySize: UINT,
    Format: DXGI_FORMAT,
    Usage: D3D11_USAGE,
    BindFlags: UINT,
    CPUAccessFlags: UINT,
    MiscFlags: UINT,
};
pub const ID3D11Texture1DVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Texture1D, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Texture1D) ULONG,
    Release: ?extern fn ([*c]ID3D11Texture1D) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11Texture1D, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11Texture1D, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Texture1D, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Texture1D, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetType: ?extern fn ([*c]ID3D11Texture1D, [*c]D3D11_RESOURCE_DIMENSION) void,
    SetEvictionPriority: ?extern fn ([*c]ID3D11Texture1D, UINT) void,
    GetEvictionPriority: ?extern fn ([*c]ID3D11Texture1D) UINT,
    GetDesc: ?extern fn ([*c]ID3D11Texture1D, [*c]D3D11_TEXTURE1D_DESC) void,
};
pub const ID3D11Texture1D = extern struct {
    lpVtbl: [*c]ID3D11Texture1DVtbl,
};
pub const DXGI_SAMPLE_DESC = extern struct {
    Count: UINT,
    Quality: UINT,
};
pub const D3D11_TEXTURE2D_DESC = extern struct {
    Width: UINT,
    Height: UINT,
    MipLevels: UINT,
    ArraySize: UINT,
    Format: DXGI_FORMAT,
    SampleDesc: DXGI_SAMPLE_DESC,
    Usage: D3D11_USAGE,
    BindFlags: UINT,
    CPUAccessFlags: UINT,
    MiscFlags: UINT,
};
pub const ID3D11Texture2DVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Texture2D, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Texture2D) ULONG,
    Release: ?extern fn ([*c]ID3D11Texture2D) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11Texture2D, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11Texture2D, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Texture2D, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Texture2D, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetType: ?extern fn ([*c]ID3D11Texture2D, [*c]D3D11_RESOURCE_DIMENSION) void,
    SetEvictionPriority: ?extern fn ([*c]ID3D11Texture2D, UINT) void,
    GetEvictionPriority: ?extern fn ([*c]ID3D11Texture2D) UINT,
    GetDesc: ?extern fn ([*c]ID3D11Texture2D, [*c]D3D11_TEXTURE2D_DESC) void,
};
pub const ID3D11Texture2D = extern struct {
    lpVtbl: [*c]ID3D11Texture2DVtbl,
};
pub const D3D11_TEXTURE3D_DESC = extern struct {
    Width: UINT,
    Height: UINT,
    Depth: UINT,
    MipLevels: UINT,
    Format: DXGI_FORMAT,
    Usage: D3D11_USAGE,
    BindFlags: UINT,
    CPUAccessFlags: UINT,
    MiscFlags: UINT,
};
pub const ID3D11Texture3DVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Texture3D, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Texture3D) ULONG,
    Release: ?extern fn ([*c]ID3D11Texture3D) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11Texture3D, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11Texture3D, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Texture3D, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Texture3D, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetType: ?extern fn ([*c]ID3D11Texture3D, [*c]D3D11_RESOURCE_DIMENSION) void,
    SetEvictionPriority: ?extern fn ([*c]ID3D11Texture3D, UINT) void,
    GetEvictionPriority: ?extern fn ([*c]ID3D11Texture3D) UINT,
    GetDesc: ?extern fn ([*c]ID3D11Texture3D, [*c]D3D11_TEXTURE3D_DESC) void,
};
pub const ID3D11Texture3D = extern struct {
    lpVtbl: [*c]ID3D11Texture3DVtbl,
};
pub const ID3D11ResourceVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Resource, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Resource) ULONG,
    Release: ?extern fn ([*c]ID3D11Resource) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11Resource, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11Resource, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Resource, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Resource, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetType: ?extern fn ([*c]ID3D11Resource, [*c]D3D11_RESOURCE_DIMENSION) void,
    SetEvictionPriority: ?extern fn ([*c]ID3D11Resource, UINT) void,
    GetEvictionPriority: ?extern fn ([*c]ID3D11Resource) UINT,
};
pub const ID3D11Resource = extern struct {
    lpVtbl: [*c]ID3D11ResourceVtbl,
};
pub const D3D_SRV_DIMENSION = extern enum {
    UNKNOWN = 0,
    BUFFER = 1,
    TEXTURE1D = 2,
    TEXTURE1DARRAY = 3,
    TEXTURE2D = 4,
    TEXTURE2DARRAY = 5,
    TEXTURE2DMS = 6,
    TEXTURE2DMSARRAY = 7,
    TEXTURE3D = 8,
    TEXTURECUBE = 9,
    TEXTURECUBEARRAY = 10,
    BUFFEREX = 11,
};
pub const D3D11_SRV_DIMENSION = D3D_SRV_DIMENSION;
pub const D3D11_BUFFER_SRV = extern struct {
    _u1: extern union {
        FirstElement: UINT,
        ElementOffset: UINT,
    },
    _u2: extern union {
        NumElements: UINT,
        ElementWidth: UINT,
    },
};
pub const D3D11_TEX1D_SRV = extern struct {
    MostDetailedMip: UINT,
    MipLevels: UINT,
};
pub const D3D11_TEX1D_ARRAY_SRV = extern struct {
    MostDetailedMip: UINT,
    MipLevels: UINT,
    FirstArraySlice: UINT,
    ArraySize: UINT,
};
pub const D3D11_TEX2D_SRV = extern struct {
    MostDetailedMip: UINT,
    MipLevels: UINT,
};
pub const D3D11_TEX2D_ARRAY_SRV = extern struct {
    MostDetailedMip: UINT,
    MipLevels: UINT,
    FirstArraySlice: UINT,
    ArraySize: UINT,
};
pub const D3D11_TEX2DMS_SRV = extern struct {
    UnusedField_NothingToDefine: UINT,
};
pub const D3D11_TEX2DMS_ARRAY_SRV = extern struct {
    FirstArraySlice: UINT,
    ArraySize: UINT,
};
pub const D3D11_TEX3D_SRV = extern struct {
    MostDetailedMip: UINT,
    MipLevels: UINT,
};
pub const D3D11_TEXCUBE_SRV = extern struct {
    MostDetailedMip: UINT,
    MipLevels: UINT,
};
pub const D3D11_TEXCUBE_ARRAY_SRV = extern struct {
    MostDetailedMip: UINT,
    MipLevels: UINT,
    First2DArrayFace: UINT,
    NumCubes: UINT,
};
pub const D3D11_BUFFEREX_SRV = extern struct {
    FirstElement: UINT,
    NumElements: UINT,
    Flags: UINT,
};
pub const D3D11_SHADER_RESOURCE_VIEW_DESC = extern struct {
    Format: DXGI_FORMAT,
    ViewDimension: D3D11_SRV_DIMENSION,
    _u: extern union {
        Buffer: D3D11_BUFFER_SRV,
        Texture1D: D3D11_TEX1D_SRV,
        Texture1DArray: D3D11_TEX1D_ARRAY_SRV,
        Texture2D: D3D11_TEX2D_SRV,
        Texture2DArray: D3D11_TEX2D_ARRAY_SRV,
        Texture2DMS: D3D11_TEX2DMS_SRV,
        Texture2DMSArray: D3D11_TEX2DMS_ARRAY_SRV,
        Texture3D: D3D11_TEX3D_SRV,
        TextureCube: D3D11_TEXCUBE_SRV,
        TextureCubeArray: D3D11_TEXCUBE_ARRAY_SRV,
        BufferEx: D3D11_BUFFEREX_SRV,
    },
};
pub const ID3D11ShaderResourceViewVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11ShaderResourceView, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11ShaderResourceView) ULONG,
    Release: ?extern fn ([*c]ID3D11ShaderResourceView) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11ShaderResourceView, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11ShaderResourceView, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11ShaderResourceView, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11ShaderResourceView, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetResource: ?extern fn ([*c]ID3D11ShaderResourceView, [*c]([*c]ID3D11Resource)) void,
    GetDesc: ?extern fn ([*c]ID3D11ShaderResourceView, [*c]D3D11_SHADER_RESOURCE_VIEW_DESC) void,
};
pub const ID3D11ShaderResourceView = extern struct {
    lpVtbl: [*c]ID3D11ShaderResourceViewVtbl,
};
pub const D3D11_UAV_DIMENSION = extern enum {
    UNKNOWN = 0,
    BUFFER = 1,
    TEXTURE1D = 2,
    TEXTURE1DARRAY = 3,
    TEXTURE2D = 4,
    TEXTURE2DARRAY = 5,
    TEXTURE3D = 8,
};
pub const D3D11_BUFFER_UAV = extern struct {
    FirstElement: UINT,
    NumElements: UINT,
    Flags: UINT,
};
pub const D3D11_TEX1D_UAV = extern struct {
    MipSlice: UINT,
};
pub const D3D11_TEX1D_ARRAY_UAV = extern struct {
    MipSlice: UINT,
    FirstArraySlice: UINT,
    ArraySize: UINT,
};
pub const D3D11_TEX2D_UAV = extern struct {
    MipSlice: UINT,
};
pub const D3D11_TEX2D_ARRAY_UAV = extern struct {
    MipSlice: UINT,
    FirstArraySlice: UINT,
    ArraySize: UINT,
};
pub const D3D11_TEX3D_UAV = extern struct {
    MipSlice: UINT,
    FirstWSlice: UINT,
    WSize: UINT,
};
pub const D3D11_UNORDERED_ACCESS_VIEW_DESC = extern struct {
    Format: DXGI_FORMAT,
    ViewDimension: D3D11_UAV_DIMENSION,
    _u: extern union {
        Buffer: D3D11_BUFFER_UAV,
        Texture1D: D3D11_TEX1D_UAV,
        Texture1DArray: D3D11_TEX1D_ARRAY_UAV,
        Texture2D: D3D11_TEX2D_UAV,
        Texture2DArray: D3D11_TEX2D_ARRAY_UAV,
        Texture3D: D3D11_TEX3D_UAV,
    },
};
pub const ID3D11UnorderedAccessViewVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11UnorderedAccessView, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11UnorderedAccessView) ULONG,
    Release: ?extern fn ([*c]ID3D11UnorderedAccessView) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11UnorderedAccessView, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11UnorderedAccessView, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11UnorderedAccessView, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11UnorderedAccessView, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetResource: ?extern fn ([*c]ID3D11UnorderedAccessView, [*c]([*c]ID3D11Resource)) void,
    GetDesc: ?extern fn ([*c]ID3D11UnorderedAccessView, [*c]D3D11_UNORDERED_ACCESS_VIEW_DESC) void,
};
pub const ID3D11UnorderedAccessView = extern struct {
    lpVtbl: [*c]ID3D11UnorderedAccessViewVtbl,
};
pub const D3D11_RTV_DIMENSION = extern enum {
    UNKNOWN = 0,
    BUFFER = 1,
    TEXTURE1D = 2,
    TEXTURE1DARRAY = 3,
    TEXTURE2D = 4,
    TEXTURE2DARRAY = 5,
    TEXTURE2DMS = 6,
    TEXTURE2DMSARRAY = 7,
    TEXTURE3D = 8,
};
pub const D3D11_BUFFER_RTV = extern struct {
    _u1: extern union {
        FirstElement: UINT,
        ElementOffset: UINT,
    },
    _u2: extern union {
        NumElements: UINT,
        ElementWidth: UINT,
    },
};

pub const D3D11_TEX1D_RTV = extern struct {
    MipSlice: UINT,
};

pub const D3D11_TEX1D_ARRAY_RTV = extern struct {
    MipSlice: UINT,
    FirstArraySlice: UINT,
    ArraySize: UINT,
};

pub const D3D11_TEX2D_RTV = extern struct {
    MipSlice: UINT,
};

pub const D3D11_TEX2D_ARRAY_RTV = extern struct {
    MipSlice: UINT,
    FirstArraySlice: UINT,
    ArraySize: UINT,
};

pub const D3D11_TEX2DMS_RTV = extern struct {
    UnusedField_NothingToDefine: UINT,
};

pub const D3D11_TEX2DMS_ARRAY_RTV = extern struct {
    FirstArraySlice: UINT,
    ArraySize: UINT,
};

pub const D3D11_TEX3D_RTV = extern struct {
    MipSlice: UINT,
    FirstWSlice: UINT,
    WSize: UINT,
};

pub const D3D11_RENDER_TARGET_VIEW_DESC = extern struct {
    Format: DXGI_FORMAT,
    ViewDimension: D3D11_RTV_DIMENSION,
    _u: extern union {
        Buffer: D3D11_BUFFER_RTV,
        Texture1D: D3D11_TEX1D_RTV,
        Texture1DArray: D3D11_TEX1D_ARRAY_RTV,
        Texture2D: D3D11_TEX2D_RTV,
        Texture2DArray: D3D11_TEX2D_ARRAY_RTV,
        Texture2DMS: D3D11_TEX2DMS_RTV,
        Texture2DMSArray: D3D11_TEX2DMS_ARRAY_RTV,
        Texture3D: D3D11_TEX3D_RTV,
    },
};
pub const ID3D11RenderTargetViewVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11RenderTargetView, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11RenderTargetView) ULONG,
    Release: ?extern fn ([*c]ID3D11RenderTargetView) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11RenderTargetView, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11RenderTargetView, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11RenderTargetView, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11RenderTargetView, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetResource: ?extern fn ([*c]ID3D11RenderTargetView, [*c]([*c]ID3D11Resource)) void,
    GetDesc: ?extern fn ([*c]ID3D11RenderTargetView, [*c]D3D11_RENDER_TARGET_VIEW_DESC) void,
};
pub const ID3D11RenderTargetView = extern struct {
    lpVtbl: [*c]ID3D11RenderTargetViewVtbl,
};
pub const D3D11_DSV_DIMENSION = extern enum {
    UNKNOWN = 0,
    TEXTURE1D = 1,
    TEXTURE1DARRAY = 2,
    TEXTURE2D = 3,
    TEXTURE2DARRAY = 4,
    TEXTURE2DMS = 5,
    TEXTURE2DMSARRAY = 6,
};
pub const D3D11_TEX1D_DSV = extern struct {
    MipSlice: UINT,
};

pub const D3D11_TEX1D_ARRAY_DSV = extern struct {
    MipSlice: UINT,
    FirstArraySlice: UINT,
    ArraySize: UINT,
};

pub const D3D11_TEX2D_DSV = extern struct {
    MipSlice: UINT,
};

pub const D3D11_TEX2D_ARRAY_DSV = extern struct {
    MipSlice: UINT,
    FirstArraySlice: UINT,
    ArraySize: UINT,
};

pub const D3D11_TEX2DMS_DSV = extern struct {
    UnusedField_NothingToDefine: UINT,
};

pub const D3D11_TEX2DMS_ARRAY_DSV = extern struct {
    FirstArraySlice: UINT,
    ArraySize: UINT,
};

pub const D3D11_DEPTH_STENCIL_VIEW_DESC = extern struct {
    Format: DXGI_FORMAT,
    ViewDimension: D3D11_DSV_DIMENSION,
    Flags: UINT,
    _u: extern union {
        Texture1D: D3D11_TEX1D_DSV,
        Texture1DArray: D3D11_TEX1D_ARRAY_DSV,
        Texture2D: D3D11_TEX2D_DSV,
        Texture2DArray: D3D11_TEX2D_ARRAY_DSV,
        Texture2DMS: D3D11_TEX2DMS_DSV,
        Texture2DMSArray: D3D11_TEX2DMS_ARRAY_DSV,
    },
};
pub const ID3D11DepthStencilViewVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11DepthStencilView, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11DepthStencilView) ULONG,
    Release: ?extern fn ([*c]ID3D11DepthStencilView) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11DepthStencilView, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11DepthStencilView, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11DepthStencilView, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11DepthStencilView, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetResource: ?extern fn ([*c]ID3D11DepthStencilView, [*c]([*c]ID3D11Resource)) void,
    GetDesc: ?extern fn ([*c]ID3D11DepthStencilView, [*c]D3D11_DEPTH_STENCIL_VIEW_DESC) void,
};
pub const ID3D11DepthStencilView = extern struct {
    lpVtbl: [*c]ID3D11DepthStencilViewVtbl,
};
pub const D3D11_INPUT_CLASSIFICATION = extern enum {
    PER_VERTEX_DATA = 0,
    PER_INSTANCE_DATA = 1,
};
pub const D3D11_INPUT_ELEMENT_DESC = extern struct {
    SemanticName: LPCSTR,
    SemanticIndex: UINT,
    Format: DXGI_FORMAT,
    InputSlot: UINT,
    AlignedByteOffset: UINT,
    InputSlotClass: D3D11_INPUT_CLASSIFICATION,
    InstanceDataStepRate: UINT,
};
pub const ID3D11InputLayoutVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11InputLayout, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11InputLayout) ULONG,
    Release: ?extern fn ([*c]ID3D11InputLayout) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11InputLayout, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11InputLayout, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11InputLayout, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11InputLayout, [*c]const GUID, [*c]const IUnknown) HRESULT,
};
pub const ID3D11InputLayout = extern struct {
    lpVtbl: [*c]ID3D11InputLayoutVtbl,
};
pub const D3D11_CLASS_INSTANCE_DESC = extern struct {
    InstanceId: UINT,
    InstanceIndex: UINT,
    TypeId: UINT,
    ConstantBuffer: UINT,
    BaseConstantBufferOffset: UINT,
    BaseTexture: UINT,
    BaseSampler: UINT,
    Created: BOOL,
};
pub const ID3D11ClassInstanceVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11ClassInstance, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11ClassInstance) ULONG,
    Release: ?extern fn ([*c]ID3D11ClassInstance) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11ClassInstance, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11ClassInstance, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11ClassInstance, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11ClassInstance, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetClassLinkage: ?extern fn ([*c]ID3D11ClassInstance, [*c]([*c]ID3D11ClassLinkage)) void,
    GetDesc: ?extern fn ([*c]ID3D11ClassInstance, [*c]D3D11_CLASS_INSTANCE_DESC) void,
    GetInstanceName: ?extern fn ([*c]ID3D11ClassInstance, LPSTR, [*c]SIZE_T) void,
    GetTypeName: ?extern fn ([*c]ID3D11ClassInstance, LPSTR, [*c]SIZE_T) void,
};
pub const ID3D11ClassInstance = extern struct {
    lpVtbl: [*c]ID3D11ClassInstanceVtbl,
};
pub const ID3D11ClassLinkageVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11ClassLinkage, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11ClassLinkage) ULONG,
    Release: ?extern fn ([*c]ID3D11ClassLinkage) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11ClassLinkage, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11ClassLinkage, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11ClassLinkage, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11ClassLinkage, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetClassInstance: ?extern fn ([*c]ID3D11ClassLinkage, LPCSTR, UINT, [*c]([*c]ID3D11ClassInstance)) HRESULT,
    CreateClassInstance: ?extern fn ([*c]ID3D11ClassLinkage, LPCSTR, UINT, UINT, UINT, UINT, [*c]([*c]ID3D11ClassInstance)) HRESULT,
};
pub const ID3D11ClassLinkage = extern struct {
    lpVtbl: [*c]ID3D11ClassLinkageVtbl,
};
pub const ID3D11VertexShaderVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11VertexShader, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11VertexShader) ULONG,
    Release: ?extern fn ([*c]ID3D11VertexShader) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11VertexShader, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11VertexShader, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11VertexShader, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11VertexShader, [*c]const GUID, [*c]const IUnknown) HRESULT,
};
pub const ID3D11VertexShader = extern struct {
    lpVtbl: [*c]ID3D11VertexShaderVtbl,
};
pub const ID3D11GeometryShaderVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11GeometryShader, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11GeometryShader) ULONG,
    Release: ?extern fn ([*c]ID3D11GeometryShader) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11GeometryShader, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11GeometryShader, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11GeometryShader, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11GeometryShader, [*c]const GUID, [*c]const IUnknown) HRESULT,
};
pub const ID3D11GeometryShader = extern struct {
    lpVtbl: [*c]ID3D11GeometryShaderVtbl,
};
pub const D3D11_SO_DECLARATION_ENTRY = extern struct {
    Stream: UINT,
    SemanticName: LPCSTR,
    SemanticIndex: UINT,
    StartComponent: BYTE,
    ComponentCount: BYTE,
    OutputSlot: BYTE,
};
pub const ID3D11PixelShaderVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11PixelShader, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11PixelShader) ULONG,
    Release: ?extern fn ([*c]ID3D11PixelShader) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11PixelShader, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11PixelShader, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11PixelShader, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11PixelShader, [*c]const GUID, [*c]const IUnknown) HRESULT,
};
pub const ID3D11PixelShader = extern struct {
    lpVtbl: [*c]ID3D11PixelShaderVtbl,
};
pub const ID3D11HullShaderVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11HullShader, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11HullShader) ULONG,
    Release: ?extern fn ([*c]ID3D11HullShader) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11HullShader, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11HullShader, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11HullShader, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11HullShader, [*c]const GUID, [*c]const IUnknown) HRESULT,
};
pub const ID3D11HullShader = extern struct {
    lpVtbl: [*c]ID3D11HullShaderVtbl,
};
pub const ID3D11DomainShaderVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11DomainShader, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11DomainShader) ULONG,
    Release: ?extern fn ([*c]ID3D11DomainShader) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11DomainShader, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11DomainShader, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11DomainShader, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11DomainShader, [*c]const GUID, [*c]const IUnknown) HRESULT,
};
pub const ID3D11DomainShader = extern struct {
    lpVtbl: [*c]ID3D11DomainShaderVtbl,
};
pub const ID3D11ComputeShaderVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11ComputeShader, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11ComputeShader) ULONG,
    Release: ?extern fn ([*c]ID3D11ComputeShader) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11ComputeShader, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11ComputeShader, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11ComputeShader, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11ComputeShader, [*c]const GUID, [*c]const IUnknown) HRESULT,
};
pub const ID3D11ComputeShader = extern struct {
    lpVtbl: [*c]ID3D11ComputeShaderVtbl,
};
pub const D3D11_BLEND = extern enum {
    ZERO = 1,
    ONE = 2,
    SRC_COLOR = 3,
    INV_SRC_COLOR = 4,
    SRC_ALPHA = 5,
    INV_SRC_ALPHA = 6,
    DEST_ALPHA = 7,
    INV_DEST_ALPHA = 8,
    DEST_COLOR = 9,
    INV_DEST_COLOR = 10,
    SRC_ALPHA_SAT = 11,
    BLEND_FACTOR = 14,
    INV_BLEND_FACTOR = 15,
    SRC1_COLOR = 16,
    INV_SRC1_COLOR = 17,
    SRC1_ALPHA = 18,
    INV_SRC1_ALPHA = 19,
};
pub const D3D11_BLEND_OP = extern enum {
    ADD = 1,
    SUBTRACT = 2,
    REV_SUBTRACT = 3,
    MIN = 4,
    MAX = 5,
};
pub const D3D11_RENDER_TARGET_BLEND_DESC = extern struct {
    BlendEnable: BOOL,
    SrcBlend: D3D11_BLEND,
    DestBlend: D3D11_BLEND,
    BlendOp: D3D11_BLEND_OP,
    SrcBlendAlpha: D3D11_BLEND,
    DestBlendAlpha: D3D11_BLEND,
    BlendOpAlpha: D3D11_BLEND_OP,
    RenderTargetWriteMask: UINT8,
};
pub const D3D11_BLEND_DESC = extern struct {
    AlphaToCoverageEnable: BOOL,
    IndependentBlendEnable: BOOL,
    RenderTarget: [8]D3D11_RENDER_TARGET_BLEND_DESC,
};
pub const ID3D11BlendStateVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11BlendState, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11BlendState) ULONG,
    Release: ?extern fn ([*c]ID3D11BlendState) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11BlendState, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11BlendState, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11BlendState, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11BlendState, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDesc: ?extern fn ([*c]ID3D11BlendState, [*c]D3D11_BLEND_DESC) void,
};
pub const ID3D11BlendState = extern struct {
    lpVtbl: [*c]ID3D11BlendStateVtbl,
};
pub const D3D11_DEPTH_WRITE_MASK = extern enum {
    ZERO = 0,
    ALL = 1,
};
pub const D3D11_COMPARISON_FUNC = extern enum {
    NEVER = 1,
    LESS = 2,
    EQUAL = 3,
    LESS_EQUAL = 4,
    GREATER = 5,
    NOT_EQUAL = 6,
    GREATER_EQUAL = 7,
    ALWAYS = 8,
};
pub const D3D11_STENCIL_OP = extern enum {
    KEEP = 1,
    ZERO = 2,
    REPLACE = 3,
    INCR_SAT = 4,
    DECR_SAT = 5,
    INVERT = 6,
    INCR = 7,
    DECR = 8,
};
pub const D3D11_DEPTH_STENCILOP_DESC = extern struct {
    StencilFailOp: D3D11_STENCIL_OP,
    StencilDepthFailOp: D3D11_STENCIL_OP,
    StencilPassOp: D3D11_STENCIL_OP,
    StencilFunc: D3D11_COMPARISON_FUNC,
};
pub const D3D11_DEPTH_STENCIL_DESC = extern struct {
    DepthEnable: BOOL,
    DepthWriteMask: D3D11_DEPTH_WRITE_MASK,
    DepthFunc: D3D11_COMPARISON_FUNC,
    StencilEnable: BOOL,
    StencilReadMask: UINT8,
    StencilWriteMask: UINT8,
    FrontFace: D3D11_DEPTH_STENCILOP_DESC,
    BackFace: D3D11_DEPTH_STENCILOP_DESC,
};
pub const ID3D11DepthStencilStateVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11DepthStencilState, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11DepthStencilState) ULONG,
    Release: ?extern fn ([*c]ID3D11DepthStencilState) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11DepthStencilState, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11DepthStencilState, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11DepthStencilState, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11DepthStencilState, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDesc: ?extern fn ([*c]ID3D11DepthStencilState, [*c]D3D11_DEPTH_STENCIL_DESC) void,
};
pub const ID3D11DepthStencilState = extern struct {
    lpVtbl: [*c]ID3D11DepthStencilStateVtbl,
};
pub const D3D11_FILL_MODE = extern enum {
    WIREFRAME = 2,
    SOLID = 3,
};
pub const D3D11_CULL_MODE = extern enum {
    NONE = 1,
    FRONT = 2,
    BACK = 3,
};
pub const D3D11_RASTERIZER_DESC = extern struct {
    FillMode: D3D11_FILL_MODE,
    CullMode: D3D11_CULL_MODE,
    FrontCounterClockwise: BOOL,
    DepthBias: INT,
    DepthBiasClamp: FLOAT,
    SlopeScaledDepthBias: FLOAT,
    DepthClipEnable: BOOL,
    ScissorEnable: BOOL,
    MultisampleEnable: BOOL,
    AntialiasedLineEnable: BOOL,
};
pub const ID3D11RasterizerStateVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11RasterizerState, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11RasterizerState) ULONG,
    Release: ?extern fn ([*c]ID3D11RasterizerState) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11RasterizerState, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11RasterizerState, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11RasterizerState, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11RasterizerState, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDesc: ?extern fn ([*c]ID3D11RasterizerState, [*c]D3D11_RASTERIZER_DESC) void,
};
pub const ID3D11RasterizerState = extern struct {
    lpVtbl: [*c]ID3D11RasterizerStateVtbl,
};
pub const D3D11_FILTER = extern enum {
    MIN_MAG_MIP_POINT = 0,
    MIN_MAG_POINT_MIP_LINEAR = 1,
    MIN_POINT_MAG_LINEAR_MIP_POINT = 4,
    MIN_POINT_MAG_MIP_LINEAR = 5,
    MIN_LINEAR_MAG_MIP_POINT = 16,
    MIN_LINEAR_MAG_POINT_MIP_LINEAR = 17,
    MIN_MAG_LINEAR_MIP_POINT = 20,
    MIN_MAG_MIP_LINEAR = 21,
    ANISOTROPIC = 85,
    COMPARISON_MIN_MAG_MIP_POINT = 128,
    COMPARISON_MIN_MAG_POINT_MIP_LINEAR = 129,
    COMPARISON_MIN_POINT_MAG_LINEAR_MIP_POINT = 132,
    COMPARISON_MIN_POINT_MAG_MIP_LINEAR = 133,
    COMPARISON_MIN_LINEAR_MAG_MIP_POINT = 144,
    COMPARISON_MIN_LINEAR_MAG_POINT_MIP_LINEAR = 145,
    COMPARISON_MIN_MAG_LINEAR_MIP_POINT = 148,
    COMPARISON_MIN_MAG_MIP_LINEAR = 149,
    COMPARISON_ANISOTROPIC = 213,
};
pub const D3D11_TEXTURE_ADDRESS_MODE = extern enum {
    WRAP = 1,
    MIRROR = 2,
    CLAMP = 3,
    BORDER = 4,
    MIRROR_ONCE = 5,
};
pub const D3D11_SAMPLER_DESC = extern struct {
    Filter: D3D11_FILTER,
    AddressU: D3D11_TEXTURE_ADDRESS_MODE,
    AddressV: D3D11_TEXTURE_ADDRESS_MODE,
    AddressW: D3D11_TEXTURE_ADDRESS_MODE,
    MipLODBias: FLOAT,
    MaxAnisotropy: UINT,
    ComparisonFunc: D3D11_COMPARISON_FUNC,
    BorderColor: [4]FLOAT,
    MinLOD: FLOAT,
    MaxLOD: FLOAT,
};
pub const ID3D11SamplerStateVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11SamplerState, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11SamplerState) ULONG,
    Release: ?extern fn ([*c]ID3D11SamplerState) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11SamplerState, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11SamplerState, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11SamplerState, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11SamplerState, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDesc: ?extern fn ([*c]ID3D11SamplerState, [*c]D3D11_SAMPLER_DESC) void,
};
pub const ID3D11SamplerState = extern struct {
    lpVtbl: [*c]ID3D11SamplerStateVtbl,
};
pub const D3D11_QUERY = extern enum {
    EVENT = 0,
    OCCLUSION = 1,
    TIMESTAMP = 2,
    TIMESTAMP_DISJOINT = 3,
    PIPELINE_STATISTICS = 4,
    OCCLUSION_PREDICATE = 5,
    SO_STATISTICS = 6,
    SO_OVERFLOW_PREDICATE = 7,
    SO_STATISTICS_STREAM0 = 8,
    SO_OVERFLOW_PREDICATE_STREAM0 = 9,
    SO_STATISTICS_STREAM1 = 10,
    SO_OVERFLOW_PREDICATE_STREAM1 = 11,
    SO_STATISTICS_STREAM2 = 12,
    SO_OVERFLOW_PREDICATE_STREAM2 = 13,
    SO_STATISTICS_STREAM3 = 14,
    SO_OVERFLOW_PREDICATE_STREAM3 = 15,
};
pub const D3D11_QUERY_DESC = extern struct {
    Query: D3D11_QUERY,
    MiscFlags: UINT,
};
pub const ID3D11QueryVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Query, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Query) ULONG,
    Release: ?extern fn ([*c]ID3D11Query) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11Query, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11Query, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Query, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Query, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDataSize: ?extern fn ([*c]ID3D11Query) UINT,
    GetDesc: ?extern fn ([*c]ID3D11Query, [*c]D3D11_QUERY_DESC) void,
};
pub const ID3D11Query = extern struct {
    lpVtbl: [*c]ID3D11QueryVtbl,
};
pub const ID3D11PredicateVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Predicate, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Predicate) ULONG,
    Release: ?extern fn ([*c]ID3D11Predicate) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11Predicate, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11Predicate, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Predicate, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Predicate, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDataSize: ?extern fn ([*c]ID3D11Predicate) UINT,
    GetDesc: ?extern fn ([*c]ID3D11Predicate, [*c]D3D11_QUERY_DESC) void,
};
pub const ID3D11Predicate = extern struct {
    lpVtbl: [*c]ID3D11PredicateVtbl,
};
pub const D3D11_COUNTER = extern enum {
    DEVICE_DEPENDENT_0 = 1073741824,
};
pub const D3D11_COUNTER_DESC = extern struct {
    Counter: D3D11_COUNTER,
    MiscFlags: UINT,
};
pub const ID3D11CounterVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Counter, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Counter) ULONG,
    Release: ?extern fn ([*c]ID3D11Counter) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11Counter, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11Counter, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Counter, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Counter, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDataSize: ?extern fn ([*c]ID3D11Counter) UINT,
    GetDesc: ?extern fn ([*c]ID3D11Counter, [*c]D3D11_COUNTER_DESC) void,
};
pub const ID3D11Counter = extern struct {
    lpVtbl: [*c]ID3D11CounterVtbl,
};
pub const D3D11_MAP = extern enum {
    READ = 1,
    WRITE = 2,
    READ_WRITE = 3,
    WRITE_DISCARD = 4,
    WRITE_NO_OVERWRITE = 5,
};
pub const D3D11_MAPPED_SUBRESOURCE = extern struct {
    pData: ?*c_void,
    RowPitch: UINT,
    DepthPitch: UINT,
};
pub const D3D_PRIMITIVE_TOPOLOGY = extern enum {
    UNDEFINED = 0,
    POINTLIST = 1,
    LINELIST = 2,
    LINESTRIP = 3,
    TRIANGLELIST = 4,
    TRIANGLESTRIP = 5,
    LINELIST_ADJ = 10,
    LINESTRIP_ADJ = 11,
    TRIANGLELIST_ADJ = 12,
    TRIANGLESTRIP_ADJ = 13,
    CONTROL_POINT_PATCHLIST_1 = 33,
    CONTROL_POINT_PATCHLIST_2 = 34,
    CONTROL_POINT_PATCHLIST_3 = 35,
    CONTROL_POINT_PATCHLIST_4 = 36,
    CONTROL_POINT_PATCHLIST_5 = 37,
    CONTROL_POINT_PATCHLIST_6 = 38,
    CONTROL_POINT_PATCHLIST_7 = 39,
    CONTROL_POINT_PATCHLIST_8 = 40,
    CONTROL_POINT_PATCHLIST_9 = 41,
    CONTROL_POINT_PATCHLIST_10 = 42,
    CONTROL_POINT_PATCHLIST_11 = 43,
    CONTROL_POINT_PATCHLIST_12 = 44,
    CONTROL_POINT_PATCHLIST_13 = 45,
    CONTROL_POINT_PATCHLIST_14 = 46,
    CONTROL_POINT_PATCHLIST_15 = 47,
    CONTROL_POINT_PATCHLIST_16 = 48,
    CONTROL_POINT_PATCHLIST_17 = 49,
    CONTROL_POINT_PATCHLIST_18 = 50,
    CONTROL_POINT_PATCHLIST_19 = 51,
    CONTROL_POINT_PATCHLIST_20 = 52,
    CONTROL_POINT_PATCHLIST_21 = 53,
    CONTROL_POINT_PATCHLIST_22 = 54,
    CONTROL_POINT_PATCHLIST_23 = 55,
    CONTROL_POINT_PATCHLIST_24 = 56,
    CONTROL_POINT_PATCHLIST_25 = 57,
    CONTROL_POINT_PATCHLIST_26 = 58,
    CONTROL_POINT_PATCHLIST_27 = 59,
    CONTROL_POINT_PATCHLIST_28 = 60,
    CONTROL_POINT_PATCHLIST_29 = 61,
    CONTROL_POINT_PATCHLIST_30 = 62,
    CONTROL_POINT_PATCHLIST_31 = 63,
    CONTROL_POINT_PATCHLIST_32 = 64,
};
pub const D3D11_PRIMITIVE_TOPOLOGY = D3D_PRIMITIVE_TOPOLOGY;
pub const ID3D11AsynchronousVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Asynchronous, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Asynchronous) ULONG,
    Release: ?extern fn ([*c]ID3D11Asynchronous) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11Asynchronous, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11Asynchronous, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Asynchronous, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Asynchronous, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDataSize: ?extern fn ([*c]ID3D11Asynchronous) UINT,
};
pub const ID3D11Asynchronous = extern struct {
    lpVtbl: [*c]ID3D11AsynchronousVtbl,
};
pub const D3D11_VIEWPORT = extern struct {
    TopLeftX: FLOAT,
    TopLeftY: FLOAT,
    Width: FLOAT,
    Height: FLOAT,
    MinDepth: FLOAT,
    MaxDepth: FLOAT,
};
pub const D3D11_RECT = RECT;
pub const D3D11_BOX = extern struct {
    left: UINT,
    top: UINT,
    front: UINT,
    right: UINT,
    bottom: UINT,
    back: UINT,
};
pub const ID3D11CommandListVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11CommandList, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11CommandList) ULONG,
    Release: ?extern fn ([*c]ID3D11CommandList) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11CommandList, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11CommandList, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11CommandList, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11CommandList, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetContextFlags: ?extern fn ([*c]ID3D11CommandList) UINT,
};
pub const ID3D11CommandList = extern struct {
    lpVtbl: [*c]ID3D11CommandListVtbl,
};
pub const D3D11_DEVICE_CONTEXT_TYPE = extern enum {
    IMMEDIATE = 0,
    DEFERRED = 1,
};
pub const ID3D11DeviceContextVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11DeviceContext, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11DeviceContext) ULONG,
    Release: ?extern fn ([*c]ID3D11DeviceContext) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11DeviceContext, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11DeviceContext, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11DeviceContext, [*c]const GUID, [*c]const IUnknown) HRESULT,
    VSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    PSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    PSSetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11PixelShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    PSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    VSSetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11VertexShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    DrawIndexed: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, INT) void,
    Draw: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT) void,
    Map: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Resource, UINT, D3D11_MAP, UINT, [*c]D3D11_MAPPED_SUBRESOURCE) HRESULT,
    Unmap: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Resource, UINT) void,
    PSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    IASetInputLayout: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11InputLayout) void,
    IASetVertexBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT, [*c]const UINT) void,
    IASetIndexBuffer: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Buffer, DXGI_FORMAT, UINT) void,
    DrawIndexedInstanced: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, UINT, INT, UINT) void,
    DrawInstanced: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, UINT, UINT) void,
    GSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    GSSetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11GeometryShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    IASetPrimitiveTopology: ?extern fn ([*c]ID3D11DeviceContext, D3D11_PRIMITIVE_TOPOLOGY) void,
    VSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    VSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    Begin: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Asynchronous) void,
    End: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Asynchronous) void,
    GetData: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Asynchronous, ?*c_void, UINT, UINT) HRESULT,
    SetPredication: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Predicate, BOOL) void,
    GSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    GSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    OMSetRenderTargets: ?extern fn ([*c]ID3D11DeviceContext, UINT, [*c]const ([*c]ID3D11RenderTargetView), [*c]ID3D11DepthStencilView) void,
    OMSetRenderTargetsAndUnorderedAccessViews: ?extern fn ([*c]ID3D11DeviceContext, UINT, [*c]const ([*c]ID3D11RenderTargetView), [*c]ID3D11DepthStencilView, UINT, UINT, [*c]const ([*c]ID3D11UnorderedAccessView), [*c]const UINT) void,
    OMSetBlendState: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11BlendState, [*c]const FLOAT, UINT) void,
    OMSetDepthStencilState: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11DepthStencilState, UINT) void,
    SOSetTargets: ?extern fn ([*c]ID3D11DeviceContext, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT) void,
    DrawAuto: ?extern fn ([*c]ID3D11DeviceContext) void,
    DrawIndexedInstancedIndirect: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Buffer, UINT) void,
    DrawInstancedIndirect: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Buffer, UINT) void,
    Dispatch: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, UINT) void,
    DispatchIndirect: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Buffer, UINT) void,
    RSSetState: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11RasterizerState) void,
    RSSetViewports: ?extern fn ([*c]ID3D11DeviceContext, UINT, [*c]const D3D11_VIEWPORT) void,
    RSSetScissorRects: ?extern fn ([*c]ID3D11DeviceContext, UINT, [*c]const D3D11_RECT) void,
    CopySubresourceRegion: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Resource, UINT, UINT, UINT, UINT, [*c]ID3D11Resource, UINT, [*c]const D3D11_BOX) void,
    CopyResource: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Resource, [*c]ID3D11Resource) void,
    UpdateSubresource: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Resource, UINT, [*c]const D3D11_BOX, ?*const c_void, UINT, UINT) void,
    CopyStructureCount: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Buffer, UINT, [*c]ID3D11UnorderedAccessView) void,
    ClearRenderTargetView: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11RenderTargetView, [*c]const FLOAT) void,
    ClearUnorderedAccessViewUint: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11UnorderedAccessView, [*c]const UINT) void,
    ClearUnorderedAccessViewFloat: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11UnorderedAccessView, [*c]const FLOAT) void,
    ClearDepthStencilView: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11DepthStencilView, UINT, FLOAT, UINT8) void,
    GenerateMips: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11ShaderResourceView) void,
    SetResourceMinLOD: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Resource, FLOAT) void,
    GetResourceMinLOD: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Resource) FLOAT,
    ResolveSubresource: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11Resource, UINT, [*c]ID3D11Resource, UINT, DXGI_FORMAT) void,
    ExecuteCommandList: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11CommandList, BOOL) void,
    HSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    HSSetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11HullShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    HSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    HSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    DSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    DSSetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11DomainShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    DSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    DSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    CSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    CSSetUnorderedAccessViews: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11UnorderedAccessView), [*c]const UINT) void,
    CSSetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]ID3D11ComputeShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    CSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    CSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    VSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    PSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    PSGetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11PixelShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    PSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    VSGetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11VertexShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    PSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    IAGetInputLayout: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11InputLayout)) void,
    IAGetVertexBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11Buffer), [*c]UINT, [*c]UINT) void,
    IAGetIndexBuffer: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11Buffer), [*c]DXGI_FORMAT, [*c]UINT) void,
    GSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    GSGetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11GeometryShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    IAGetPrimitiveTopology: ?extern fn ([*c]ID3D11DeviceContext, [*c]D3D11_PRIMITIVE_TOPOLOGY) void,
    VSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    VSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    GetPredication: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11Predicate), [*c]BOOL) void,
    GSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    GSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    OMGetRenderTargets: ?extern fn ([*c]ID3D11DeviceContext, UINT, [*c]([*c]ID3D11RenderTargetView), [*c]([*c]ID3D11DepthStencilView)) void,
    OMGetRenderTargetsAndUnorderedAccessViews: ?extern fn ([*c]ID3D11DeviceContext, UINT, [*c]([*c]ID3D11RenderTargetView), [*c]([*c]ID3D11DepthStencilView), UINT, UINT, [*c]([*c]ID3D11UnorderedAccessView)) void,
    OMGetBlendState: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11BlendState), [*c]FLOAT, [*c]UINT) void,
    OMGetDepthStencilState: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11DepthStencilState), [*c]UINT) void,
    SOGetTargets: ?extern fn ([*c]ID3D11DeviceContext, UINT, [*c]([*c]ID3D11Buffer)) void,
    RSGetState: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11RasterizerState)) void,
    RSGetViewports: ?extern fn ([*c]ID3D11DeviceContext, [*c]UINT, [*c]D3D11_VIEWPORT) void,
    RSGetScissorRects: ?extern fn ([*c]ID3D11DeviceContext, [*c]UINT, [*c]D3D11_RECT) void,
    HSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    HSGetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11HullShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    HSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    HSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    DSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    DSGetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11DomainShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    DSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    DSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    CSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    CSGetUnorderedAccessViews: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11UnorderedAccessView)) void,
    CSGetShader: ?extern fn ([*c]ID3D11DeviceContext, [*c]([*c]ID3D11ComputeShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    CSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    CSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    ClearState: ?extern fn ([*c]ID3D11DeviceContext) void,
    Flush: ?extern fn ([*c]ID3D11DeviceContext) void,
    GetType: ?extern fn ([*c]ID3D11DeviceContext) D3D11_DEVICE_CONTEXT_TYPE,
    GetContextFlags: ?extern fn ([*c]ID3D11DeviceContext) UINT,
    FinishCommandList: ?extern fn ([*c]ID3D11DeviceContext, BOOL, [*c]([*c]ID3D11CommandList)) HRESULT,
};
pub const ID3D11DeviceContext = extern struct {
    lpVtbl: [*c]ID3D11DeviceContextVtbl,
};
pub const D3D11_COUNTER_INFO = extern struct {
    LastDeviceDependentCounter: D3D11_COUNTER,
    NumSimultaneousCounters: UINT,
    NumDetectableParallelUnits: UINT8,
};
pub const D3D11_COUNTER_TYPE = extern enum {
    FLOAT32 = 0,
    UINT16 = 1,
    UINT32 = 2,
    UINT64 = 3,
};
pub const D3D11_FEATURE = extern enum {
    THREADING = 0,
    DOUBLES = 1,
    FORMAT_SUPPORT = 2,
    FORMAT_SUPPORT2 = 3,
    D3D10_X_HARDWARE_OPTIONS = 4,
    D3D11_OPTIONS = 5,
    ARCHITECTURE_INFO = 6,
    D3D9_OPTIONS = 7,
    SHADER_MIN_PRECISION_SUPPORT = 8,
    D3D9_SHADOW_SUPPORT = 9,
    D3D11_OPTIONS1 = 10,
    D3D9_SIMPLE_INSTANCING_SUPPORT = 11,
    MARKER_SUPPORT = 12,
    D3D9_OPTIONS1 = 13,
    D3D11_OPTIONS2 = 14,
    D3D11_OPTIONS3 = 15,
    GPU_VIRTUAL_ADDRESS_SUPPORT = 16,
    D3D11_OPTIONS4 = 17,
    SHADER_CACHE = 18,
};
pub const D3D_FEATURE_LEVEL = extern enum {
    Level_9_1 = 37120,
    Level_9_2 = 37376,
    Level_9_3 = 37632,
    Level_10_0 = 40960,
    Level_10_1 = 41216,
    Level_11_0 = 45056,
    Level_11_1 = 45312,
    Level_12_0 = 49152,
    Level_12_1 = 49408,
};

pub const IUnknownVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]IUnknown, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]IUnknown) ULONG,
    Release: ?extern fn ([*c]IUnknown) ULONG,
};

pub const IUnknown = extern struct {
    lpVtbl: [*c]IUnknownVtbl,
};

pub const ID3D11DeviceVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Device, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Device) ULONG,
    Release: ?extern fn ([*c]ID3D11Device) ULONG,
    CreateBuffer: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_BUFFER_DESC, [*c]const D3D11_SUBRESOURCE_DATA, [*c]([*c]ID3D11Buffer)) HRESULT,
    CreateTexture1D: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_TEXTURE1D_DESC, [*c]const D3D11_SUBRESOURCE_DATA, [*c]([*c]ID3D11Texture1D)) HRESULT,
    CreateTexture2D: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_TEXTURE2D_DESC, [*c]const D3D11_SUBRESOURCE_DATA, [*c]([*c]ID3D11Texture2D)) HRESULT,
    CreateTexture3D: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_TEXTURE3D_DESC, [*c]const D3D11_SUBRESOURCE_DATA, [*c]([*c]ID3D11Texture3D)) HRESULT,
    CreateShaderResourceView: ?extern fn ([*c]ID3D11Device, [*c]ID3D11Resource, [*c]const D3D11_SHADER_RESOURCE_VIEW_DESC, [*c]([*c]ID3D11ShaderResourceView)) HRESULT,
    CreateUnorderedAccessView: ?extern fn ([*c]ID3D11Device, [*c]ID3D11Resource, [*c]const D3D11_UNORDERED_ACCESS_VIEW_DESC, [*c]([*c]ID3D11UnorderedAccessView)) HRESULT,
    CreateRenderTargetView: ?extern fn ([*c]ID3D11Device, [*c]ID3D11Resource, [*c]const D3D11_RENDER_TARGET_VIEW_DESC, [*c]([*c]ID3D11RenderTargetView)) HRESULT,
    CreateDepthStencilView: ?extern fn ([*c]ID3D11Device, [*c]ID3D11Resource, [*c]const D3D11_DEPTH_STENCIL_VIEW_DESC, [*c]([*c]ID3D11DepthStencilView)) HRESULT,
    CreateInputLayout: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_INPUT_ELEMENT_DESC, UINT, ?*const c_void, SIZE_T, [*c]([*c]ID3D11InputLayout)) HRESULT,
    CreateVertexShader: ?extern fn ([*c]ID3D11Device, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11VertexShader)) HRESULT,
    CreateGeometryShader: ?extern fn ([*c]ID3D11Device, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11GeometryShader)) HRESULT,
    CreateGeometryShaderWithStreamOutput: ?extern fn ([*c]ID3D11Device, ?*const c_void, SIZE_T, [*c]const D3D11_SO_DECLARATION_ENTRY, UINT, [*c]const UINT, UINT, UINT, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11GeometryShader)) HRESULT,
    CreatePixelShader: ?extern fn ([*c]ID3D11Device, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11PixelShader)) HRESULT,
    CreateHullShader: ?extern fn ([*c]ID3D11Device, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11HullShader)) HRESULT,
    CreateDomainShader: ?extern fn ([*c]ID3D11Device, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11DomainShader)) HRESULT,
    CreateComputeShader: ?extern fn ([*c]ID3D11Device, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11ComputeShader)) HRESULT,
    CreateClassLinkage: ?extern fn ([*c]ID3D11Device, [*c]([*c]ID3D11ClassLinkage)) HRESULT,
    CreateBlendState: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_BLEND_DESC, [*c]([*c]ID3D11BlendState)) HRESULT,
    CreateDepthStencilState: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_DEPTH_STENCIL_DESC, [*c]([*c]ID3D11DepthStencilState)) HRESULT,
    CreateRasterizerState: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_RASTERIZER_DESC, [*c]([*c]ID3D11RasterizerState)) HRESULT,
    CreateSamplerState: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_SAMPLER_DESC, [*c]([*c]ID3D11SamplerState)) HRESULT,
    CreateQuery: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_QUERY_DESC, [*c]([*c]ID3D11Query)) HRESULT,
    CreatePredicate: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_QUERY_DESC, [*c]([*c]ID3D11Predicate)) HRESULT,
    CreateCounter: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_COUNTER_DESC, [*c]([*c]ID3D11Counter)) HRESULT,
    CreateDeferredContext: ?extern fn ([*c]ID3D11Device, UINT, [*c]([*c]ID3D11DeviceContext)) HRESULT,
    OpenSharedResource: ?extern fn ([*c]ID3D11Device, HANDLE, [*c]const IID, [*c](?*c_void)) HRESULT,
    CheckFormatSupport: ?extern fn ([*c]ID3D11Device, DXGI_FORMAT, [*c]UINT) HRESULT,
    CheckMultisampleQualityLevels: ?extern fn ([*c]ID3D11Device, DXGI_FORMAT, UINT, [*c]UINT) HRESULT,
    CheckCounterInfo: ?extern fn ([*c]ID3D11Device, [*c]D3D11_COUNTER_INFO) void,
    CheckCounter: ?extern fn ([*c]ID3D11Device, [*c]const D3D11_COUNTER_DESC, [*c]D3D11_COUNTER_TYPE, [*c]UINT, LPSTR, [*c]UINT, LPSTR, [*c]UINT, LPSTR, [*c]UINT) HRESULT,
    CheckFeatureSupport: ?extern fn ([*c]ID3D11Device, D3D11_FEATURE, ?*c_void, UINT) HRESULT,
    GetPrivateData: ?extern fn ([*c]ID3D11Device, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Device, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Device, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetFeatureLevel: ?extern fn ([*c]ID3D11Device) D3D_FEATURE_LEVEL,
    GetCreationFlags: ?extern fn ([*c]ID3D11Device) UINT,
    GetDeviceRemovedReason: ?extern fn ([*c]ID3D11Device) HRESULT,
    GetImmediateContext: ?extern fn ([*c]ID3D11Device, [*c]([*c]ID3D11DeviceContext)) void,
    SetExceptionMode: ?extern fn ([*c]ID3D11Device, UINT) HRESULT,
    GetExceptionMode: ?extern fn ([*c]ID3D11Device) UINT,
};

pub const ID3D11Device = extern struct {
    lpVtbl: [*c]ID3D11DeviceVtbl,
};

pub const D3D11_LOGIC_OP = extern enum {
    CLEAR = 0,
    SET = 1,
    COPY = 2,
    COPY_INVERTED = 3,
    NOOP = 4,
    INVERT = 5,
    AND = 6,
    NAND = 7,
    OR = 8,
    NOR = 9,
    XOR = 10,
    EQUIV = 11,
    AND_REVERSE = 12,
    AND_INVERTED = 13,
    OR_REVERSE = 14,
    OR_INVERTED = 15,
};
pub const D3D11_RENDER_TARGET_BLEND_DESC1 = extern struct {
    BlendEnable: BOOL,
    LogicOpEnable: BOOL,
    SrcBlend: D3D11_BLEND,
    DestBlend: D3D11_BLEND,
    BlendOp: D3D11_BLEND_OP,
    SrcBlendAlpha: D3D11_BLEND,
    DestBlendAlpha: D3D11_BLEND,
    BlendOpAlpha: D3D11_BLEND_OP,
    LogicOp: D3D11_LOGIC_OP,
    RenderTargetWriteMask: UINT8,
};
pub const D3D11_BLEND_DESC1 = extern struct {
    AlphaToCoverageEnable: BOOL,
    IndependentBlendEnable: BOOL,
    RenderTarget: [8]D3D11_RENDER_TARGET_BLEND_DESC1,
};
pub const ID3D11BlendState1Vtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11BlendState1, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11BlendState1) ULONG,
    Release: ?extern fn ([*c]ID3D11BlendState1) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11BlendState1, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11BlendState1, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11BlendState1, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11BlendState1, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDesc: ?extern fn ([*c]ID3D11BlendState1, [*c]D3D11_BLEND_DESC) void,
    GetDesc1: ?extern fn ([*c]ID3D11BlendState1, [*c]D3D11_BLEND_DESC1) void,
};
pub const ID3D11BlendState1 = extern struct {
    lpVtbl: [*c]ID3D11BlendState1Vtbl,
};
pub const ID3DDeviceContextStateVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3DDeviceContextState, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3DDeviceContextState) ULONG,
    Release: ?extern fn ([*c]ID3DDeviceContextState) ULONG,
    GetDevice: ?extern fn ([*c]ID3DDeviceContextState, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3DDeviceContextState, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3DDeviceContextState, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3DDeviceContextState, [*c]const GUID, [*c]const IUnknown) HRESULT,
};
pub const ID3DDeviceContextState = extern struct {
    lpVtbl: [*c]ID3DDeviceContextStateVtbl,
};
pub const ID3D11ViewVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11View, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11View) ULONG,
    Release: ?extern fn ([*c]ID3D11View) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11View, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11View, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11View, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11View, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetResource: ?extern fn ([*c]ID3D11View, [*c]([*c]ID3D11Resource)) void,
};
pub const ID3D11View = extern struct {
    lpVtbl: [*c]ID3D11ViewVtbl,
};
pub const ID3D11DeviceContext1Vtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11DeviceContext1, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11DeviceContext1) ULONG,
    Release: ?extern fn ([*c]ID3D11DeviceContext1) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11DeviceContext1, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11DeviceContext1, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11DeviceContext1, [*c]const GUID, [*c]const IUnknown) HRESULT,
    VSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    PSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    PSSetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11PixelShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    PSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    VSSetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11VertexShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    DrawIndexed: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, INT) void,
    Draw: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT) void,
    Map: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource, UINT, D3D11_MAP, UINT, [*c]D3D11_MAPPED_SUBRESOURCE) HRESULT,
    Unmap: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource, UINT) void,
    PSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    IASetInputLayout: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11InputLayout) void,
    IASetVertexBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT, [*c]const UINT) void,
    IASetIndexBuffer: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Buffer, DXGI_FORMAT, UINT) void,
    DrawIndexedInstanced: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, UINT, INT, UINT) void,
    DrawInstanced: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, UINT, UINT) void,
    GSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    GSSetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11GeometryShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    IASetPrimitiveTopology: ?extern fn ([*c]ID3D11DeviceContext1, D3D11_PRIMITIVE_TOPOLOGY) void,
    VSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    VSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    Begin: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Asynchronous) void,
    End: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Asynchronous) void,
    GetData: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Asynchronous, ?*c_void, UINT, UINT) HRESULT,
    SetPredication: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Predicate, BOOL) void,
    GSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    GSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    OMSetRenderTargets: ?extern fn ([*c]ID3D11DeviceContext1, UINT, [*c]const ([*c]ID3D11RenderTargetView), [*c]ID3D11DepthStencilView) void,
    OMSetRenderTargetsAndUnorderedAccessViews: ?extern fn ([*c]ID3D11DeviceContext1, UINT, [*c]const ([*c]ID3D11RenderTargetView), [*c]ID3D11DepthStencilView, UINT, UINT, [*c]const ([*c]ID3D11UnorderedAccessView), [*c]const UINT) void,
    OMSetBlendState: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11BlendState, [*c]const FLOAT, UINT) void,
    OMSetDepthStencilState: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11DepthStencilState, UINT) void,
    SOSetTargets: ?extern fn ([*c]ID3D11DeviceContext1, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT) void,
    DrawAuto: ?extern fn ([*c]ID3D11DeviceContext1) void,
    DrawIndexedInstancedIndirect: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Buffer, UINT) void,
    DrawInstancedIndirect: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Buffer, UINT) void,
    Dispatch: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, UINT) void,
    DispatchIndirect: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Buffer, UINT) void,
    RSSetState: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11RasterizerState) void,
    RSSetViewports: ?extern fn ([*c]ID3D11DeviceContext1, UINT, [*c]const D3D11_VIEWPORT) void,
    RSSetScissorRects: ?extern fn ([*c]ID3D11DeviceContext1, UINT, [*c]const D3D11_RECT) void,
    CopySubresourceRegion: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource, UINT, UINT, UINT, UINT, [*c]ID3D11Resource, UINT, [*c]const D3D11_BOX) void,
    CopyResource: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource, [*c]ID3D11Resource) void,
    UpdateSubresource: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource, UINT, [*c]const D3D11_BOX, ?*const c_void, UINT, UINT) void,
    CopyStructureCount: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Buffer, UINT, [*c]ID3D11UnorderedAccessView) void,
    ClearRenderTargetView: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11RenderTargetView, [*c]const FLOAT) void,
    ClearUnorderedAccessViewUint: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11UnorderedAccessView, [*c]const UINT) void,
    ClearUnorderedAccessViewFloat: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11UnorderedAccessView, [*c]const FLOAT) void,
    ClearDepthStencilView: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11DepthStencilView, UINT, FLOAT, UINT8) void,
    GenerateMips: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11ShaderResourceView) void,
    SetResourceMinLOD: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource, FLOAT) void,
    GetResourceMinLOD: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource) FLOAT,
    ResolveSubresource: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource, UINT, [*c]ID3D11Resource, UINT, DXGI_FORMAT) void,
    ExecuteCommandList: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11CommandList, BOOL) void,
    HSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    HSSetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11HullShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    HSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    HSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    DSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    DSSetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11DomainShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    DSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    DSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    CSSetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11ShaderResourceView)) void,
    CSSetUnorderedAccessViews: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11UnorderedAccessView), [*c]const UINT) void,
    CSSetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11ComputeShader, [*c]const ([*c]ID3D11ClassInstance), UINT) void,
    CSSetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11SamplerState)) void,
    CSSetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer)) void,
    VSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    PSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    PSGetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11PixelShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    PSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    VSGetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11VertexShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    PSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    IAGetInputLayout: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11InputLayout)) void,
    IAGetVertexBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer), [*c]UINT, [*c]UINT) void,
    IAGetIndexBuffer: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11Buffer), [*c]DXGI_FORMAT, [*c]UINT) void,
    GSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    GSGetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11GeometryShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    IAGetPrimitiveTopology: ?extern fn ([*c]ID3D11DeviceContext1, [*c]D3D11_PRIMITIVE_TOPOLOGY) void,
    VSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    VSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    GetPredication: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11Predicate), [*c]BOOL) void,
    GSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    GSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    OMGetRenderTargets: ?extern fn ([*c]ID3D11DeviceContext1, UINT, [*c]([*c]ID3D11RenderTargetView), [*c]([*c]ID3D11DepthStencilView)) void,
    OMGetRenderTargetsAndUnorderedAccessViews: ?extern fn ([*c]ID3D11DeviceContext1, UINT, [*c]([*c]ID3D11RenderTargetView), [*c]([*c]ID3D11DepthStencilView), UINT, UINT, [*c]([*c]ID3D11UnorderedAccessView)) void,
    OMGetBlendState: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11BlendState), [*c]FLOAT, [*c]UINT) void,
    OMGetDepthStencilState: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11DepthStencilState), [*c]UINT) void,
    SOGetTargets: ?extern fn ([*c]ID3D11DeviceContext1, UINT, [*c]([*c]ID3D11Buffer)) void,
    RSGetState: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11RasterizerState)) void,
    RSGetViewports: ?extern fn ([*c]ID3D11DeviceContext1, [*c]UINT, [*c]D3D11_VIEWPORT) void,
    RSGetScissorRects: ?extern fn ([*c]ID3D11DeviceContext1, [*c]UINT, [*c]D3D11_RECT) void,
    HSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    HSGetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11HullShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    HSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    HSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    DSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    DSGetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11DomainShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    DSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    DSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    CSGetShaderResources: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11ShaderResourceView)) void,
    CSGetUnorderedAccessViews: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11UnorderedAccessView)) void,
    CSGetShader: ?extern fn ([*c]ID3D11DeviceContext1, [*c]([*c]ID3D11ComputeShader), [*c]([*c]ID3D11ClassInstance), [*c]UINT) void,
    CSGetSamplers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11SamplerState)) void,
    CSGetConstantBuffers: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer)) void,
    ClearState: ?extern fn ([*c]ID3D11DeviceContext1) void,
    Flush: ?extern fn ([*c]ID3D11DeviceContext1) void,
    GetType: ?extern fn ([*c]ID3D11DeviceContext1) D3D11_DEVICE_CONTEXT_TYPE,
    GetContextFlags: ?extern fn ([*c]ID3D11DeviceContext1) UINT,
    FinishCommandList: ?extern fn ([*c]ID3D11DeviceContext1, BOOL, [*c]([*c]ID3D11CommandList)) HRESULT,
    CopySubresourceRegion1: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource, UINT, UINT, UINT, UINT, [*c]ID3D11Resource, UINT, [*c]const D3D11_BOX, UINT) void,
    UpdateSubresource1: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource, UINT, [*c]const D3D11_BOX, ?*const c_void, UINT, UINT, UINT) void,
    DiscardResource: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11Resource) void,
    DiscardView: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11View) void,
    VSSetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT, [*c]const UINT) void,
    HSSetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT, [*c]const UINT) void,
    DSSetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT, [*c]const UINT) void,
    GSSetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT, [*c]const UINT) void,
    PSSetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT, [*c]const UINT) void,
    CSSetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]const ([*c]ID3D11Buffer), [*c]const UINT, [*c]const UINT) void,
    VSGetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer), [*c]UINT, [*c]UINT) void,
    HSGetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer), [*c]UINT, [*c]UINT) void,
    DSGetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer), [*c]UINT, [*c]UINT) void,
    GSGetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer), [*c]UINT, [*c]UINT) void,
    PSGetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer), [*c]UINT, [*c]UINT) void,
    CSGetConstantBuffers1: ?extern fn ([*c]ID3D11DeviceContext1, UINT, UINT, [*c]([*c]ID3D11Buffer), [*c]UINT, [*c]UINT) void,
    SwapDeviceContextState: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3DDeviceContextState, [*c]([*c]ID3DDeviceContextState)) void,
    ClearView: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11View, [*c]const FLOAT, [*c]const D3D11_RECT, UINT) void,
    DiscardView1: ?extern fn ([*c]ID3D11DeviceContext1, [*c]ID3D11View, [*c]const D3D11_RECT, UINT) void,
};
pub const ID3D11DeviceContext1 = extern struct {
    lpVtbl: [*c]ID3D11DeviceContext1Vtbl,
};
pub const DXGI_RATIONAL = extern struct {
    Numerator: UINT,
    Denominator: UINT,
};
pub const D3D11_RASTERIZER_DESC1 = extern struct {
    FillMode: D3D11_FILL_MODE,
    CullMode: D3D11_CULL_MODE,
    FrontCounterClockwise: BOOL,
    DepthBias: INT,
    DepthBiasClamp: FLOAT,
    SlopeScaledDepthBias: FLOAT,
    DepthClipEnable: BOOL,
    ScissorEnable: BOOL,
    MultisampleEnable: BOOL,
    AntialiasedLineEnable: BOOL,
    ForcedSampleCount: UINT,
};
pub const ID3D11RasterizerState1Vtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11RasterizerState1, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11RasterizerState1) ULONG,
    Release: ?extern fn ([*c]ID3D11RasterizerState1) ULONG,
    GetDevice: ?extern fn ([*c]ID3D11RasterizerState1, [*c]([*c]ID3D11Device)) void,
    GetPrivateData: ?extern fn ([*c]ID3D11RasterizerState1, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11RasterizerState1, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11RasterizerState1, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetDesc: ?extern fn ([*c]ID3D11RasterizerState1, [*c]D3D11_RASTERIZER_DESC) void,
    GetDesc1: ?extern fn ([*c]ID3D11RasterizerState1, [*c]D3D11_RASTERIZER_DESC1) void,
};
pub const ID3D11RasterizerState1 = extern struct {
    lpVtbl: [*c]ID3D11RasterizerState1Vtbl,
};
pub const ID3D11Device1Vtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3D11Device1, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3D11Device1) ULONG,
    Release: ?extern fn ([*c]ID3D11Device1) ULONG,
    CreateBuffer: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_BUFFER_DESC, [*c]const D3D11_SUBRESOURCE_DATA, [*c]([*c]ID3D11Buffer)) HRESULT,
    CreateTexture1D: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_TEXTURE1D_DESC, [*c]const D3D11_SUBRESOURCE_DATA, [*c]([*c]ID3D11Texture1D)) HRESULT,
    CreateTexture2D: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_TEXTURE2D_DESC, [*c]const D3D11_SUBRESOURCE_DATA, [*c]([*c]ID3D11Texture2D)) HRESULT,
    CreateTexture3D: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_TEXTURE3D_DESC, [*c]const D3D11_SUBRESOURCE_DATA, [*c]([*c]ID3D11Texture3D)) HRESULT,
    CreateShaderResourceView: ?extern fn ([*c]ID3D11Device1, [*c]ID3D11Resource, [*c]const D3D11_SHADER_RESOURCE_VIEW_DESC, [*c]([*c]ID3D11ShaderResourceView)) HRESULT,
    CreateUnorderedAccessView: ?extern fn ([*c]ID3D11Device1, [*c]ID3D11Resource, [*c]const D3D11_UNORDERED_ACCESS_VIEW_DESC, [*c]([*c]ID3D11UnorderedAccessView)) HRESULT,
    CreateRenderTargetView: ?extern fn ([*c]ID3D11Device1, [*c]ID3D11Resource, [*c]const D3D11_RENDER_TARGET_VIEW_DESC, [*c]([*c]ID3D11RenderTargetView)) HRESULT,
    CreateDepthStencilView: ?extern fn ([*c]ID3D11Device1, [*c]ID3D11Resource, [*c]const D3D11_DEPTH_STENCIL_VIEW_DESC, [*c]([*c]ID3D11DepthStencilView)) HRESULT,
    CreateInputLayout: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_INPUT_ELEMENT_DESC, UINT, ?*const c_void, SIZE_T, [*c]([*c]ID3D11InputLayout)) HRESULT,
    CreateVertexShader: ?extern fn ([*c]ID3D11Device1, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11VertexShader)) HRESULT,
    CreateGeometryShader: ?extern fn ([*c]ID3D11Device1, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11GeometryShader)) HRESULT,
    CreateGeometryShaderWithStreamOutput: ?extern fn ([*c]ID3D11Device1, ?*const c_void, SIZE_T, [*c]const D3D11_SO_DECLARATION_ENTRY, UINT, [*c]const UINT, UINT, UINT, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11GeometryShader)) HRESULT,
    CreatePixelShader: ?extern fn ([*c]ID3D11Device1, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11PixelShader)) HRESULT,
    CreateHullShader: ?extern fn ([*c]ID3D11Device1, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11HullShader)) HRESULT,
    CreateDomainShader: ?extern fn ([*c]ID3D11Device1, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11DomainShader)) HRESULT,
    CreateComputeShader: ?extern fn ([*c]ID3D11Device1, ?*const c_void, SIZE_T, [*c]ID3D11ClassLinkage, [*c]([*c]ID3D11ComputeShader)) HRESULT,
    CreateClassLinkage: ?extern fn ([*c]ID3D11Device1, [*c]([*c]ID3D11ClassLinkage)) HRESULT,
    CreateBlendState: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_BLEND_DESC, [*c]([*c]ID3D11BlendState)) HRESULT,
    CreateDepthStencilState: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_DEPTH_STENCIL_DESC, [*c]([*c]ID3D11DepthStencilState)) HRESULT,
    CreateRasterizerState: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_RASTERIZER_DESC, [*c]([*c]ID3D11RasterizerState)) HRESULT,
    CreateSamplerState: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_SAMPLER_DESC, [*c]([*c]ID3D11SamplerState)) HRESULT,
    CreateQuery: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_QUERY_DESC, [*c]([*c]ID3D11Query)) HRESULT,
    CreatePredicate: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_QUERY_DESC, [*c]([*c]ID3D11Predicate)) HRESULT,
    CreateCounter: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_COUNTER_DESC, [*c]([*c]ID3D11Counter)) HRESULT,
    CreateDeferredContext: ?extern fn ([*c]ID3D11Device1, UINT, [*c]([*c]ID3D11DeviceContext)) HRESULT,
    OpenSharedResource: ?extern fn ([*c]ID3D11Device1, HANDLE, [*c]const IID, [*c](?*c_void)) HRESULT,
    CheckFormatSupport: ?extern fn ([*c]ID3D11Device1, DXGI_FORMAT, [*c]UINT) HRESULT,
    CheckMultisampleQualityLevels: ?extern fn ([*c]ID3D11Device1, DXGI_FORMAT, UINT, [*c]UINT) HRESULT,
    CheckCounterInfo: ?extern fn ([*c]ID3D11Device1, [*c]D3D11_COUNTER_INFO) void,
    CheckCounter: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_COUNTER_DESC, [*c]D3D11_COUNTER_TYPE, [*c]UINT, LPSTR, [*c]UINT, LPSTR, [*c]UINT, LPSTR, [*c]UINT) HRESULT,
    CheckFeatureSupport: ?extern fn ([*c]ID3D11Device1, D3D11_FEATURE, ?*c_void, UINT) HRESULT,
    GetPrivateData: ?extern fn ([*c]ID3D11Device1, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    SetPrivateData: ?extern fn ([*c]ID3D11Device1, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]ID3D11Device1, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetFeatureLevel: ?extern fn ([*c]ID3D11Device1) D3D_FEATURE_LEVEL,
    GetCreationFlags: ?extern fn ([*c]ID3D11Device1) UINT,
    GetDeviceRemovedReason: ?extern fn ([*c]ID3D11Device1) HRESULT,
    GetImmediateContext: ?extern fn ([*c]ID3D11Device1, [*c]([*c]ID3D11DeviceContext)) void,
    SetExceptionMode: ?extern fn ([*c]ID3D11Device1, UINT) HRESULT,
    GetExceptionMode: ?extern fn ([*c]ID3D11Device1) UINT,
    GetImmediateContext1: ?extern fn ([*c]ID3D11Device1, [*c]([*c]ID3D11DeviceContext1)) void,
    CreateDeferredContext1: ?extern fn ([*c]ID3D11Device1, UINT, [*c]([*c]ID3D11DeviceContext1)) HRESULT,
    CreateBlendState1: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_BLEND_DESC1, [*c]([*c]ID3D11BlendState1)) HRESULT,
    CreateRasterizerState1: ?extern fn ([*c]ID3D11Device1, [*c]const D3D11_RASTERIZER_DESC1, [*c]([*c]ID3D11RasterizerState1)) HRESULT,
    CreateDeviceContextState: ?extern fn ([*c]ID3D11Device1, UINT, [*c]const D3D_FEATURE_LEVEL, UINT, UINT, [*c]const IID, [*c]D3D_FEATURE_LEVEL, [*c]([*c]ID3DDeviceContextState)) HRESULT,
    OpenSharedResource1: ?extern fn ([*c]ID3D11Device1, HANDLE, [*c]const IID, [*c](?*c_void)) HRESULT,
    OpenSharedResourceByName: ?extern fn ([*c]ID3D11Device1, LPCWSTR, DWORD, [*c]const IID, [*c](?*c_void)) HRESULT,
};
pub const ID3D11Device1 = extern struct {
    lpVtbl: [*c]ID3D11Device1Vtbl,
};
pub const DXGI_MODE_SCANLINE_ORDER = extern enum {
    UNSPECIFIED = 0,
    PROGRESSIVE = 1,
    UPPER_FIELD_FIRST = 2,
    LOWER_FIELD_FIRST = 3,
};
pub const DXGI_MODE_SCALING = extern enum {
    UNSPECIFIED = 0,
    CENTERED = 1,
    STRETCHED = 2,
};
pub const DXGI_MODE_DESC = extern struct {
    Width: UINT,
    Height: UINT,
    RefreshRate: DXGI_RATIONAL,
    Format: DXGI_FORMAT,
    ScanlineOrdering: DXGI_MODE_SCANLINE_ORDER,
    Scaling: DXGI_MODE_SCALING,
};
pub const DXGI_MODE_ROTATION = extern enum {
    UNSPECIFIED = 0,
    IDENTITY = 1,
    ROTATE90 = 2,
    ROTATE180 = 3,
    ROTATE270 = 4,
};
pub const DXGI_USAGE = extern enum(UINT) {
    SHADER_INPUT = 16,
    RENDER_TARGET_OUTPUT = 32,
    BACK_BUFFER = 64,
    SHARED = 128,
    READ_ONLY = 256,
    DISCARD_ON_PRESENT = 512,
    UNORDERED_ACCESS = 1024,
};
pub const DXGI_MAPPED_RECT = extern struct {
    Pitch: INT,
    pBits: [*c]BYTE,
};
pub const DXGI_SURFACE_DESC = extern struct {
    Width: UINT,
    Height: UINT,
    Format: DXGI_FORMAT,
    SampleDesc: DXGI_SAMPLE_DESC,
};
pub const HMONITOR = *@OpaqueType();
pub const DXGI_OUTPUT_DESC = extern struct {
    DeviceName: [32]WCHAR,
    DesktopCoordinates: RECT,
    AttachedToDesktop: BOOL,
    Rotation: DXGI_MODE_ROTATION,
    Monitor: HMONITOR,
};
pub const DXGI_GAMMA_CONTROL_CAPABILITIES = extern struct {
    ScaleAndOffsetSupported: BOOL,
    MaxConvertedValue: f32,
    MinConvertedValue: f32,
    NumGammaControlPoints: UINT,
    ControlPointPositions: [1025]f32,
};
pub const DXGI_RGB = extern struct {
    Red: f32,
    Green: f32,
    Blue: f32,
};
pub const DXGI_GAMMA_CONTROL = extern struct {
    Scale: DXGI_RGB,
    Offset: DXGI_RGB,
    GammaCurve: [1025]DXGI_RGB,
};
pub const IDXGISurfaceVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]IDXGISurface, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]IDXGISurface) ULONG,
    Release: ?extern fn ([*c]IDXGISurface) ULONG,
    SetPrivateData: ?extern fn ([*c]IDXGISurface, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]IDXGISurface, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetPrivateData: ?extern fn ([*c]IDXGISurface, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    GetParent: ?extern fn ([*c]IDXGISurface, [*c]const IID, [*c](?*c_void)) HRESULT,
    GetDevice: ?extern fn ([*c]IDXGISurface, [*c]const IID, [*c](?*c_void)) HRESULT,
    GetDesc: ?extern fn ([*c]IDXGISurface, [*c]DXGI_SURFACE_DESC) HRESULT,
    Map: ?extern fn ([*c]IDXGISurface, [*c]DXGI_MAPPED_RECT, UINT) HRESULT,
    Unmap: ?extern fn ([*c]IDXGISurface) HRESULT,
};
pub const IDXGISurface = extern struct {
    lpVtbl: [*c]IDXGISurfaceVtbl,
};
pub const DXGI_FRAME_STATISTICS = extern struct {
    PresentCount: UINT,
    PresentRefreshCount: UINT,
    SyncRefreshCount: UINT,
    SyncQPCTime: LARGE_INTEGER,
    SyncGPUTime: LARGE_INTEGER,
};
pub const IDXGIOutputVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]IDXGIOutput, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]IDXGIOutput) ULONG,
    Release: ?extern fn ([*c]IDXGIOutput) ULONG,
    SetPrivateData: ?extern fn ([*c]IDXGIOutput, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]IDXGIOutput, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetPrivateData: ?extern fn ([*c]IDXGIOutput, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    GetParent: ?extern fn ([*c]IDXGIOutput, [*c]const IID, [*c](?*c_void)) HRESULT,
    GetDesc: ?extern fn ([*c]IDXGIOutput, [*c]DXGI_OUTPUT_DESC) HRESULT,
    GetDisplayModeList: ?extern fn ([*c]IDXGIOutput, DXGI_FORMAT, UINT, [*c]UINT, [*c]DXGI_MODE_DESC) HRESULT,
    FindClosestMatchingMode: ?extern fn ([*c]IDXGIOutput, [*c]const DXGI_MODE_DESC, [*c]DXGI_MODE_DESC, [*c]IUnknown) HRESULT,
    WaitForVBlank: ?extern fn ([*c]IDXGIOutput) HRESULT,
    TakeOwnership: ?extern fn ([*c]IDXGIOutput, [*c]IUnknown, BOOL) HRESULT,
    ReleaseOwnership: ?extern fn ([*c]IDXGIOutput) void,
    GetGammaControlCapabilities: ?extern fn ([*c]IDXGIOutput, [*c]DXGI_GAMMA_CONTROL_CAPABILITIES) HRESULT,
    SetGammaControl: ?extern fn ([*c]IDXGIOutput, [*c]const DXGI_GAMMA_CONTROL) HRESULT,
    GetGammaControl: ?extern fn ([*c]IDXGIOutput, [*c]DXGI_GAMMA_CONTROL) HRESULT,
    SetDisplaySurface: ?extern fn ([*c]IDXGIOutput, [*c]IDXGISurface) HRESULT,
    GetDisplaySurfaceData: ?extern fn ([*c]IDXGIOutput, [*c]IDXGISurface) HRESULT,
    GetFrameStatistics: ?extern fn ([*c]IDXGIOutput, [*c]DXGI_FRAME_STATISTICS) HRESULT,
};
pub const IDXGIOutput = extern struct {
    lpVtbl: [*c]IDXGIOutputVtbl,
};
pub const DXGI_ADAPTER_DESC = extern struct {
    Description: [128]WCHAR,
    VendorId: UINT,
    DeviceId: UINT,
    SubSysId: UINT,
    Revision: UINT,
    DedicatedVideoMemory: SIZE_T,
    DedicatedSystemMemory: SIZE_T,
    SharedSystemMemory: SIZE_T,
    AdapterLuid: LUID,
};
pub const IDXGIAdapterVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]IDXGIAdapter, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]IDXGIAdapter) ULONG,
    Release: ?extern fn ([*c]IDXGIAdapter) ULONG,
    SetPrivateData: ?extern fn ([*c]IDXGIAdapter, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]IDXGIAdapter, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetPrivateData: ?extern fn ([*c]IDXGIAdapter, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    GetParent: ?extern fn ([*c]IDXGIAdapter, [*c]const IID, [*c](?*c_void)) HRESULT,
    EnumOutputs: ?extern fn ([*c]IDXGIAdapter, UINT, [*c]([*c]IDXGIOutput)) HRESULT,
    GetDesc: ?extern fn ([*c]IDXGIAdapter, [*c]DXGI_ADAPTER_DESC) HRESULT,
    CheckInterfaceSupport: ?extern fn ([*c]IDXGIAdapter, [*c]const GUID, [*c]LARGE_INTEGER) HRESULT,
};
pub const IDXGIAdapter = extern struct {
    lpVtbl: [*c]IDXGIAdapterVtbl,
};
pub const DXGI_SHARED_RESOURCE = extern struct {
    Handle: HANDLE,
};
pub const DXGI_RESIDENCY = extern enum {
    FULLY_RESIDENT = 1,
    RESIDENT_IN_SHARED_MEMORY = 2,
    EVICTED_TO_DISK = 3,
};
pub const DXGI_SWAP_EFFECT = extern enum {
    DISCARD = 0,
    SEQUENTIAL = 1,
    FLIP_SEQUENTIAL = 3,
    FLIP_DISCARD = 4,
};
pub const DXGI_SWAP_CHAIN_DESC = extern struct {
    BufferDesc: DXGI_MODE_DESC,
    SampleDesc: DXGI_SAMPLE_DESC,
    BufferUsage: DXGI_USAGE,
    BufferCount: UINT,
    OutputWindow: HWND,
    Windowed: BOOL,
    SwapEffect: DXGI_SWAP_EFFECT,
    Flags: UINT,
};
pub const DXGI_SCALING = extern enum {
    STRETCH = 0,
    NONE = 1,
};
pub const DXGI_ALPHA_MODE = extern enum(DWORD) {
    UNSPECIFIED = 0,
    PREMULTIPLIED = 1,
    STRAIGHT = 2,
    IGNORE = 3,
};
pub const DXGI_SWAP_CHAIN_DESC1 = extern struct {
    Width: UINT,
    Height: UINT,
    Format: DXGI_FORMAT,
    Stereo: BOOL,
    SampleDesc: DXGI_SAMPLE_DESC,
    BufferUsage: DXGI_USAGE,
    BufferCount: UINT,
    Scaling: DXGI_SCALING,
    SwapEffect: DXGI_SWAP_EFFECT,
    AlphaMode: DXGI_ALPHA_MODE,
    Flags: UINT,
};
pub const DXGI_SWAP_CHAIN_FULLSCREEN_DESC = extern struct {
    RefreshRate: DXGI_RATIONAL,
    ScanlineOrdering: DXGI_MODE_SCANLINE_ORDER,
    Scaling: DXGI_MODE_SCALING,
    Windowed: BOOL,
};
pub const DXGI_PRESENT_PARAMETERS = extern struct {
    DirtyRectsCount: UINT,
    pDirtyRects: [*c]RECT,
    pScrollRect: [*c]RECT,
    pScrollOffset: [*c]POINT,
};
pub const D3DCOLORVALUE = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};
pub const DXGI_RGBA = D3DCOLORVALUE;
pub const IDXGISwapChain1Vtbl = extern struct {
    QueryInterface: ?extern fn ([*c]IDXGISwapChain1, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]IDXGISwapChain1) ULONG,
    Release: ?extern fn ([*c]IDXGISwapChain1) ULONG,
    SetPrivateData: ?extern fn ([*c]IDXGISwapChain1, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]IDXGISwapChain1, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetPrivateData: ?extern fn ([*c]IDXGISwapChain1, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    GetParent: ?extern fn ([*c]IDXGISwapChain1, [*c]const IID, [*c](?*c_void)) HRESULT,
    GetDevice: ?extern fn ([*c]IDXGISwapChain1, [*c]const IID, [*c](?*c_void)) HRESULT,
    Present: ?extern fn ([*c]IDXGISwapChain1, UINT, UINT) HRESULT,
    GetBuffer: ?extern fn ([*c]IDXGISwapChain1, UINT, [*c]const IID, [*c](?*c_void)) HRESULT,
    SetFullscreenState: ?extern fn ([*c]IDXGISwapChain1, BOOL, [*c]IDXGIOutput) HRESULT,
    GetFullscreenState: ?extern fn ([*c]IDXGISwapChain1, [*c]BOOL, [*c]([*c]IDXGIOutput)) HRESULT,
    GetDesc: ?extern fn ([*c]IDXGISwapChain1, [*c]DXGI_SWAP_CHAIN_DESC) HRESULT,
    ResizeBuffers: ?extern fn ([*c]IDXGISwapChain1, UINT, UINT, UINT, DXGI_FORMAT, UINT) HRESULT,
    ResizeTarget: ?extern fn ([*c]IDXGISwapChain1, [*c]const DXGI_MODE_DESC) HRESULT,
    GetContainingOutput: ?extern fn ([*c]IDXGISwapChain1, [*c]([*c]IDXGIOutput)) HRESULT,
    GetFrameStatistics: ?extern fn ([*c]IDXGISwapChain1, [*c]DXGI_FRAME_STATISTICS) HRESULT,
    GetLastPresentCount: ?extern fn ([*c]IDXGISwapChain1, [*c]UINT) HRESULT,
    GetDesc1: ?extern fn ([*c]IDXGISwapChain1, [*c]DXGI_SWAP_CHAIN_DESC1) HRESULT,
    GetFullscreenDesc: ?extern fn ([*c]IDXGISwapChain1, [*c]DXGI_SWAP_CHAIN_FULLSCREEN_DESC) HRESULT,
    GetHwnd: ?extern fn ([*c]IDXGISwapChain1, [*c]HWND) HRESULT,
    GetCoreWindow: ?extern fn ([*c]IDXGISwapChain1, [*c]const IID, [*c](?*c_void)) HRESULT,
    Present1: ?extern fn ([*c]IDXGISwapChain1, UINT, UINT, [*c]const DXGI_PRESENT_PARAMETERS) HRESULT,
    IsTemporaryMonoSupported: ?extern fn ([*c]IDXGISwapChain1) BOOL,
    GetRestrictToOutput: ?extern fn ([*c]IDXGISwapChain1, [*c]([*c]IDXGIOutput)) HRESULT,
    SetBackgroundColor: ?extern fn ([*c]IDXGISwapChain1, [*c]const DXGI_RGBA) HRESULT,
    GetBackgroundColor: ?extern fn ([*c]IDXGISwapChain1, [*c]DXGI_RGBA) HRESULT,
    SetRotation: ?extern fn ([*c]IDXGISwapChain1, DXGI_MODE_ROTATION) HRESULT,
    GetRotation: ?extern fn ([*c]IDXGISwapChain1, [*c]DXGI_MODE_ROTATION) HRESULT,
};
pub const IDXGISwapChain1 = extern struct {
    lpVtbl: [*c]IDXGISwapChain1Vtbl,
};
pub const IDXGISwapChainVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]IDXGISwapChain, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]IDXGISwapChain) ULONG,
    Release: ?extern fn ([*c]IDXGISwapChain) ULONG,
    SetPrivateData: ?extern fn ([*c]IDXGISwapChain, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]IDXGISwapChain, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetPrivateData: ?extern fn ([*c]IDXGISwapChain, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    GetParent: ?extern fn ([*c]IDXGISwapChain, [*c]const IID, [*c](?*c_void)) HRESULT,
    GetDevice: ?extern fn ([*c]IDXGISwapChain, [*c]const IID, [*c](?*c_void)) HRESULT,
    Present: ?extern fn ([*c]IDXGISwapChain, UINT, UINT) HRESULT,
    GetBuffer: ?extern fn ([*c]IDXGISwapChain, UINT, [*c]const IID, [*c](?*c_void)) HRESULT,
    SetFullscreenState: ?extern fn ([*c]IDXGISwapChain, BOOL, [*c]IDXGIOutput) HRESULT,
    GetFullscreenState: ?extern fn ([*c]IDXGISwapChain, [*c]BOOL, [*c]([*c]IDXGIOutput)) HRESULT,
    GetDesc: ?extern fn ([*c]IDXGISwapChain, [*c]DXGI_SWAP_CHAIN_DESC) HRESULT,
    ResizeBuffers: ?extern fn ([*c]IDXGISwapChain, UINT, UINT, UINT, DXGI_FORMAT, UINT) HRESULT,
    ResizeTarget: ?extern fn ([*c]IDXGISwapChain, [*c]const DXGI_MODE_DESC) HRESULT,
    GetContainingOutput: ?extern fn ([*c]IDXGISwapChain, [*c]([*c]IDXGIOutput)) HRESULT,
    GetFrameStatistics: ?extern fn ([*c]IDXGISwapChain, [*c]DXGI_FRAME_STATISTICS) HRESULT,
    GetLastPresentCount: ?extern fn ([*c]IDXGISwapChain, [*c]UINT) HRESULT,
};
pub const IDXGISwapChain = extern struct {
    lpVtbl: [*c]IDXGISwapChainVtbl,
};
pub const DXGI_ADAPTER_DESC1 = extern struct {
    Description: [128]WCHAR,
    VendorId: UINT,
    DeviceId: UINT,
    SubSysId: UINT,
    Revision: UINT,
    DedicatedVideoMemory: SIZE_T,
    DedicatedSystemMemory: SIZE_T,
    SharedSystemMemory: SIZE_T,
    AdapterLuid: LUID,
    Flags: UINT,
};
pub const IDXGIAdapter1Vtbl = extern struct {
    QueryInterface: ?extern fn ([*c]IDXGIAdapter1, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]IDXGIAdapter1) ULONG,
    Release: ?extern fn ([*c]IDXGIAdapter1) ULONG,
    SetPrivateData: ?extern fn ([*c]IDXGIAdapter1, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]IDXGIAdapter1, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetPrivateData: ?extern fn ([*c]IDXGIAdapter1, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    GetParent: ?extern fn ([*c]IDXGIAdapter1, [*c]const IID, [*c](?*c_void)) HRESULT,
    EnumOutputs: ?extern fn ([*c]IDXGIAdapter1, UINT, [*c]([*c]IDXGIOutput)) HRESULT,
    GetDesc: ?extern fn ([*c]IDXGIAdapter1, [*c]DXGI_ADAPTER_DESC) HRESULT,
    CheckInterfaceSupport: ?extern fn ([*c]IDXGIAdapter1, [*c]const GUID, [*c]LARGE_INTEGER) HRESULT,
    GetDesc1: ?extern fn ([*c]IDXGIAdapter1, [*c]DXGI_ADAPTER_DESC1) HRESULT,
};
pub const IDXGIAdapter1 = extern struct {
    lpVtbl: [*c]IDXGIAdapter1Vtbl,
};
pub const IDXGIFactory2Vtbl = extern struct {
    QueryInterface: ?extern fn ([*c]IDXGIFactory2, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]IDXGIFactory2) ULONG,
    Release: ?extern fn ([*c]IDXGIFactory2) ULONG,
    SetPrivateData: ?extern fn ([*c]IDXGIFactory2, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]IDXGIFactory2, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetPrivateData: ?extern fn ([*c]IDXGIFactory2, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    GetParent: ?extern fn ([*c]IDXGIFactory2, [*c]const IID, [*c](?*c_void)) HRESULT,
    EnumAdapters: ?extern fn ([*c]IDXGIFactory2, UINT, [*c]([*c]IDXGIAdapter)) HRESULT,
    MakeWindowAssociation: ?extern fn ([*c]IDXGIFactory2, HWND, UINT) HRESULT,
    GetWindowAssociation: ?extern fn ([*c]IDXGIFactory2, [*c]HWND) HRESULT,
    CreateSwapChain: ?extern fn ([*c]IDXGIFactory2, [*c]IUnknown, [*c]DXGI_SWAP_CHAIN_DESC, [*c]([*c]IDXGISwapChain)) HRESULT,
    CreateSoftwareAdapter: ?extern fn ([*c]IDXGIFactory2, HMODULE, [*c]([*c]IDXGIAdapter)) HRESULT,
    EnumAdapters1: ?extern fn ([*c]IDXGIFactory2, UINT, [*c]([*c]IDXGIAdapter1)) HRESULT,
    IsCurrent: ?extern fn ([*c]IDXGIFactory2) BOOL,
    IsWindowedStereoEnabled: ?extern fn ([*c]IDXGIFactory2) BOOL,
    CreateSwapChainForHwnd: ?extern fn ([*c]IDXGIFactory2, [*c]IUnknown, HWND, [*c]const DXGI_SWAP_CHAIN_DESC1, [*c]const DXGI_SWAP_CHAIN_FULLSCREEN_DESC, [*c]IDXGIOutput, [*c]([*c]IDXGISwapChain1)) HRESULT,
    CreateSwapChainForCoreWindow: ?extern fn ([*c]IDXGIFactory2, [*c]IUnknown, [*c]IUnknown, [*c]const DXGI_SWAP_CHAIN_DESC1, [*c]IDXGIOutput, [*c]([*c]IDXGISwapChain1)) HRESULT,
    GetSharedResourceAdapterLuid: ?extern fn ([*c]IDXGIFactory2, HANDLE, [*c]LUID) HRESULT,
    RegisterOcclusionStatusWindow: ?extern fn ([*c]IDXGIFactory2, HWND, UINT, [*c]DWORD) HRESULT,
    RegisterStereoStatusEvent: ?extern fn ([*c]IDXGIFactory2, HANDLE, [*c]DWORD) HRESULT,
    UnregisterStereoStatus: ?extern fn ([*c]IDXGIFactory2, DWORD) void,
    RegisterStereoStatusWindow: ?extern fn ([*c]IDXGIFactory2, HWND, UINT, [*c]DWORD) HRESULT,
    RegisterOcclusionStatusEvent: ?extern fn ([*c]IDXGIFactory2, HANDLE, [*c]DWORD) HRESULT,
    UnregisterOcclusionStatus: ?extern fn ([*c]IDXGIFactory2, DWORD) void,
    CreateSwapChainForComposition: ?extern fn ([*c]IDXGIFactory2, [*c]IUnknown, [*c]const DXGI_SWAP_CHAIN_DESC1, [*c]IDXGIOutput, [*c]([*c]IDXGISwapChain1)) HRESULT,
};
pub const IDXGIFactory2 = extern struct {
    lpVtbl: [*c]IDXGIFactory2Vtbl,
};
pub const IDXGIDevice1Vtbl = extern struct {
    QueryInterface: ?extern fn ([*c]IDXGIDevice1, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]IDXGIDevice1) ULONG,
    Release: ?extern fn ([*c]IDXGIDevice1) ULONG,
    SetPrivateData: ?extern fn ([*c]IDXGIDevice1, [*c]const GUID, UINT, ?*const c_void) HRESULT,
    SetPrivateDataInterface: ?extern fn ([*c]IDXGIDevice1, [*c]const GUID, [*c]const IUnknown) HRESULT,
    GetPrivateData: ?extern fn ([*c]IDXGIDevice1, [*c]const GUID, [*c]UINT, ?*c_void) HRESULT,
    GetParent: ?extern fn ([*c]IDXGIDevice1, [*c]const IID, [*c](?*c_void)) HRESULT,
    GetAdapter: ?extern fn ([*c]IDXGIDevice1, [*c]([*c]IDXGIAdapter)) HRESULT,
    CreateSurface: ?extern fn ([*c]IDXGIDevice1, [*c]const DXGI_SURFACE_DESC, UINT, DXGI_USAGE, [*c]const DXGI_SHARED_RESOURCE, [*c]([*c]IDXGISurface)) HRESULT,
    QueryResourceResidency: ?extern fn ([*c]IDXGIDevice1, [*c]const ([*c]IUnknown), [*c]DXGI_RESIDENCY, UINT) HRESULT,
    SetGPUThreadPriority: ?extern fn ([*c]IDXGIDevice1, INT) HRESULT,
    GetGPUThreadPriority: ?extern fn ([*c]IDXGIDevice1, [*c]INT) HRESULT,
    SetMaximumFrameLatency: ?extern fn ([*c]IDXGIDevice1, UINT) HRESULT,
    GetMaximumFrameLatency: ?extern fn ([*c]IDXGIDevice1, [*c]UINT) HRESULT,
};
pub const IDXGIDevice1 = extern struct {
    lpVtbl: [*c]IDXGIDevice1Vtbl,
};
pub const ID3DBlobVtbl = extern struct {
    QueryInterface: ?extern fn ([*c]ID3DBlob, [*c]const IID, [*c](?*c_void)) HRESULT,
    AddRef: ?extern fn ([*c]ID3DBlob) ULONG,
    Release: ?extern fn ([*c]ID3DBlob) ULONG,
    GetBufferPointer: ?extern fn ([*c]ID3DBlob) ?*c_void,
    GetBufferSize: ?extern fn ([*c]ID3DBlob) SIZE_T,
};
pub const ID3DBlob = extern struct {
    lpVtbl: [*c]ID3DBlobVtbl,
};
pub const D3D_INCLUDE_TYPE = extern enum(DWORD) {
    LOCAL = 0,
    SYSTEM = 1,
};
pub const ID3DIncludeVtbl = extern struct {
    Open: ?extern fn ([*c]ID3DInclude, D3D_INCLUDE_TYPE, [*c]const u8, ?*const c_void, [*c](?*const c_void), [*c]UINT) HRESULT,
    Close: ?extern fn ([*c]ID3DInclude, ?*const c_void) HRESULT,
};
pub const ID3DInclude = extern struct {
    lpVtbl: [*c]ID3DIncludeVtbl,
};
pub const D3D_SHADER_MACRO = extern struct {
    Name: [*c]const u8,
    Definition: [*c]const u8,
};
pub const D3D_DRIVER_TYPE = extern enum {
    UNKNOWN = 0,
    HARDWARE = 1,
    REFERENCE = 2,
    NULL = 3,
    SOFTWARE = 4,
    WARP = 5,
};
pub const D3D11_BIND_FLAG = extern enum {
    VERTEX_BUFFER = 1,
    INDEX_BUFFER = 2,
    CONSTANT_BUFFER = 4,
    SHADER_RESOURCE = 8,
    STREAM_OUTPUT = 16,
    RENDER_TARGET = 32,
    DEPTH_STENCIL = 64,
    UNORDERED_ACCESS = 128,
    DECODER = 512,
    VIDEO_ENCODER = 1024,
};
pub const D3D11_CPU_ACCESS_FLAG = extern enum {
    WRITE = 65536,
    READ = 131072,
};
pub const D3D11_COLOR_WRITE_ENABLE = extern enum {
    RED = 1,
    GREEN = 2,
    BLUE = 4,
    ALPHA = 8,
    ALL = 15,
};
pub const D3D11_CLEAR_FLAG = extern enum {
    DEPTH = 1,
    STENCIL = 2,
};
pub const D3D11_CREATE_DEVICE_FLAG = extern enum {
    SINGLETHREADED = 1,
    DEBUG = 2,
    SWITCH_TO_REF = 4,
    PREVENT_INTERNAL_THREADING_OPTIMIZATIONS = 8,
    BGRA_SUPPORT = 32,
    DEBUGGABLE = 64,
    PREVENT_ALTERING_LAYER_SETTINGS_FROM_REGISTRY = 128,
    DISABLE_GPU_TIMEOUT = 256,
    VIDEO_SUPPORT = 2048,
};
pub extern fn D3D11CreateDevice(arg0: [*c]IDXGIAdapter, arg1: D3D_DRIVER_TYPE, arg2: HMODULE, arg3: D3D11_CREATE_DEVICE_FLAG, arg4: [*c]const D3D_FEATURE_LEVEL, arg5: UINT, arg6: UINT, arg7: [*c]([*c]ID3D11Device), arg8: [*c]D3D_FEATURE_LEVEL, arg9: [*c]([*c]ID3D11DeviceContext)) HRESULT;
pub extern fn D3DCompile(data: ?*const c_void, data_size: SIZE_T, filename: [*c]const u8, defines: [*c]const D3D_SHADER_MACRO, include: [*c]ID3DInclude, entrypoint: [*c]const u8, target: [*c]const u8, sflags: UINT, eflags: UINT, shader: [*c]([*c]ID3DBlob), error_messages: [*c]([*c]ID3DBlob)) HRESULT;
pub const TRUE = 1;
pub const D3D11_SDK_VERSION = 7;
pub const D3D11_APPEND_ALIGNED_ELEMENT = 4294967295;
pub const D3D11_DEFAULT_STENCIL_READ_MASK = 255;
pub const FALSE = 0;

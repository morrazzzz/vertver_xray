/*
Copyright (c) 2022, NVIDIA CORPORATION. All rights reserved.

NVIDIA CORPORATION and its licensors retain all intellectual property
and proprietary rights in and to this software, related documentation
and any modifications thereto. Any use, reproduction, disclosure or
distribution of this software and related documentation without an express
license agreement from NVIDIA CORPORATION is strictly prohibited.
*/

#pragma once

namespace nri
{

struct DeviceD3D11;

struct FrameBufferD3D11
{
    inline ~FrameBufferD3D11()
    {}

    inline DeviceD3D11& GetDevice() const
    { return m_Device; }

    FrameBufferD3D11(DeviceD3D11& device, const FrameBufferDesc& desc);

    void Bind(VersionedContext& context, RenderPassBeginFlag renderPassBeginFlag) const;
    void ClearAttachments(VersionedContext& context, const ClearDesc* clearDescs, uint32_t clearDescNum, const Rect* rects, uint32_t rectNum) const;

    //================================================================================================================
    // NRI
    //================================================================================================================

    inline void SetDebugName(const char* name)
    { MaybeUnused(name); }

private:
    DeviceD3D11& m_Device;
    Vector<ClearDesc> m_ClearDescs;
    Vector<ID3D11RenderTargetView*> m_RenderTargets;
    ID3D11DepthStencilView* m_DepthStencil = nullptr;
};

}

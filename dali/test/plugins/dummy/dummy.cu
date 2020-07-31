// Copyright (c) 2017-2018, NVIDIA CORPORATION. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <cuda_runtime_api.h>
#include "dali/test/plugins/dummy/dummy.h"

namespace other_ns {

template<>
void Dummy<::dali::GPUBackend>::RunImpl(::dali::DeviceWorkspace &ws) {
  auto &input = ws.Input<::dali::GPUBackend>(0);
  auto &output = ws.Output<::dali::GPUBackend>(0);
  output.set_type(input.type());
  output.ResizeLike(input);
  output.SetLayout(input.GetLayout());
  CUDA_CALL(cudaMemcpyAsync(
          output.raw_mutable_data(),
          input.raw_data(),
          input.nbytes(),
          cudaMemcpyDeviceToDevice,
          ws.stream()));
}

}  // namespace other_ns

DALI_REGISTER_OPERATOR(CustomDummy, ::other_ns::Dummy<::dali::GPUBackend>, ::dali::GPU);



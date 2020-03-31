{-# language CPP #-}
module Graphics.Vulkan.Core10.SparseResourceMemoryManagement  ( getImageSparseMemoryRequirements
                                                              , getPhysicalDeviceSparseImageFormatProperties
                                                              , queueBindSparse
                                                              , SparseImageFormatProperties(..)
                                                              , SparseImageMemoryRequirements(..)
                                                              , SparseMemoryBind(..)
                                                              , SparseImageMemoryBind(..)
                                                              , SparseBufferMemoryBindInfo(..)
                                                              , SparseImageOpaqueMemoryBindInfo(..)
                                                              , SparseImageMemoryBindInfo(..)
                                                              , BindSparseInfo(..)
                                                              ) where

import Control.Exception.Base (bracket)
import Data.Typeable (eqT)
import Foreign.Marshal.Alloc (allocaBytesAligned)
import Foreign.Marshal.Alloc (callocBytes)
import Foreign.Marshal.Alloc (free)
import GHC.Base (when)
import GHC.IO (throwIO)
import GHC.Ptr (castPtr)
import Foreign.Ptr (nullPtr)
import Foreign.Ptr (plusPtr)
import Control.Monad.Trans.Class (lift)
import Control.Monad.Trans.Cont (evalContT)
import Data.Vector (generateM)
import qualified Data.Vector (imapM_)
import qualified Data.Vector (length)
import Data.Type.Equality ((:~:)(Refl))
import Data.Typeable (Typeable)
import Foreign.Storable (Storable)
import Foreign.Storable (Storable(peek))
import Foreign.Storable (Storable(poke))
import qualified Foreign.Storable (Storable(..))
import Foreign.Ptr (FunPtr)
import Foreign.Ptr (Ptr)
import Data.Word (Word32)
import Data.Kind (Type)
import Control.Monad.Trans.Cont (ContT(..))
import Data.Vector (Vector)
import Graphics.Vulkan.CStruct.Utils (advancePtrBytes)
import Graphics.Vulkan.NamedType ((:::))
import Graphics.Vulkan.Core10.Handles (Buffer)
import Graphics.Vulkan.CStruct.Extends (Chain)
import Graphics.Vulkan.Core10.Handles (Device)
import Graphics.Vulkan.Core10.Handles (Device(..))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkGetImageSparseMemoryRequirements))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkQueueBindSparse))
import {-# SOURCE #-} Graphics.Vulkan.Core11.Promoted_From_VK_KHR_device_group (DeviceGroupBindSparseInfo)
import Graphics.Vulkan.Core10.Handles (DeviceMemory)
import Graphics.Vulkan.Core10.BaseType (DeviceSize)
import Graphics.Vulkan.Core10.Handles (Device_T)
import Graphics.Vulkan.CStruct.Extends (Extends)
import Graphics.Vulkan.CStruct.Extends (Extensible(..))
import Graphics.Vulkan.Core10.SharedTypes (Extent3D)
import Graphics.Vulkan.Core10.Handles (Fence)
import Graphics.Vulkan.Core10.Handles (Fence(..))
import Graphics.Vulkan.Core10.Enums.Format (Format)
import Graphics.Vulkan.Core10.Enums.Format (Format(..))
import Graphics.Vulkan.CStruct (FromCStruct)
import Graphics.Vulkan.CStruct (FromCStruct(..))
import Graphics.Vulkan.Core10.Handles (Image)
import Graphics.Vulkan.Core10.Handles (Image(..))
import Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits (ImageAspectFlags)
import Graphics.Vulkan.Core10.Image (ImageSubresource)
import Graphics.Vulkan.Core10.Enums.ImageTiling (ImageTiling)
import Graphics.Vulkan.Core10.Enums.ImageTiling (ImageTiling(..))
import Graphics.Vulkan.Core10.Enums.ImageType (ImageType)
import Graphics.Vulkan.Core10.Enums.ImageType (ImageType(..))
import Graphics.Vulkan.Core10.Enums.ImageUsageFlagBits (ImageUsageFlags)
import Graphics.Vulkan.Core10.Enums.ImageUsageFlagBits (ImageUsageFlags)
import Graphics.Vulkan.Core10.Enums.ImageUsageFlagBits (ImageUsageFlagBits(..))
import Graphics.Vulkan.Dynamic (InstanceCmds(pVkGetPhysicalDeviceSparseImageFormatProperties))
import Graphics.Vulkan.Core10.SharedTypes (Offset3D)
import Graphics.Vulkan.CStruct.Extends (PeekChain)
import Graphics.Vulkan.CStruct.Extends (PeekChain(..))
import Graphics.Vulkan.Core10.Handles (PhysicalDevice)
import Graphics.Vulkan.Core10.Handles (PhysicalDevice(..))
import Graphics.Vulkan.Core10.Handles (PhysicalDevice_T)
import Graphics.Vulkan.CStruct.Extends (PokeChain)
import Graphics.Vulkan.CStruct.Extends (PokeChain(..))
import Graphics.Vulkan.Core10.Handles (Queue)
import Graphics.Vulkan.Core10.Handles (Queue(..))
import Graphics.Vulkan.Core10.Handles (Queue_T)
import Graphics.Vulkan.Core10.Enums.Result (Result)
import Graphics.Vulkan.Core10.Enums.Result (Result(..))
import Graphics.Vulkan.Core10.Enums.SampleCountFlagBits (SampleCountFlagBits)
import Graphics.Vulkan.Core10.Enums.SampleCountFlagBits (SampleCountFlagBits(..))
import Graphics.Vulkan.Core10.Handles (Semaphore)
import Graphics.Vulkan.Core10.Enums.SparseImageFormatFlagBits (SparseImageFormatFlags)
import Graphics.Vulkan.Core10.Enums.SparseMemoryBindFlagBits (SparseMemoryBindFlags)
import Graphics.Vulkan.Core10.Enums.StructureType (StructureType)
import {-# SOURCE #-} Graphics.Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore (TimelineSemaphoreSubmitInfo)
import Graphics.Vulkan.CStruct (ToCStruct)
import Graphics.Vulkan.CStruct (ToCStruct(..))
import Graphics.Vulkan.Exception (VulkanException(..))
import Graphics.Vulkan.Zero (Zero(..))
import Graphics.Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_BIND_SPARSE_INFO))
import Graphics.Vulkan.Core10.Enums.Result (Result(SUCCESS))
foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkGetImageSparseMemoryRequirements
  :: FunPtr (Ptr Device_T -> Image -> Ptr Word32 -> Ptr SparseImageMemoryRequirements -> IO ()) -> Ptr Device_T -> Image -> Ptr Word32 -> Ptr SparseImageMemoryRequirements -> IO ()

-- | vkGetImageSparseMemoryRequirements - Query the memory requirements for a
-- sparse image
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' is the logical device that
--     owns the image.
--
-- -   'Graphics.Vulkan.Core10.Handles.Image' is the
--     'Graphics.Vulkan.Core10.Handles.Image' object to get the memory
--     requirements for.
--
-- -   @pSparseMemoryRequirementCount@ is a pointer to an integer related
--     to the number of sparse memory requirements available or queried, as
--     described below.
--
-- -   @pSparseMemoryRequirements@ is either @NULL@ or a pointer to an
--     array of 'SparseImageMemoryRequirements' structures.
--
-- = Description
--
-- If @pSparseMemoryRequirements@ is @NULL@, then the number of sparse
-- memory requirements available is returned in
-- @pSparseMemoryRequirementCount@. Otherwise,
-- @pSparseMemoryRequirementCount@ /must/ point to a variable set by the
-- user to the number of elements in the @pSparseMemoryRequirements@ array,
-- and on return the variable is overwritten with the number of structures
-- actually written to @pSparseMemoryRequirements@. If
-- @pSparseMemoryRequirementCount@ is less than the number of sparse memory
-- requirements available, at most @pSparseMemoryRequirementCount@
-- structures will be written.
--
-- If the image was not created with
-- 'Graphics.Vulkan.Core10.Enums.ImageCreateFlagBits.IMAGE_CREATE_SPARSE_RESIDENCY_BIT'
-- then @pSparseMemoryRequirementCount@ will be set to zero and
-- @pSparseMemoryRequirements@ will not be written to.
--
-- Note
--
-- It is legal for an implementation to report a larger value in
-- 'Graphics.Vulkan.Core10.MemoryManagement.MemoryRequirements'::@size@
-- than would be obtained by adding together memory sizes for all
-- 'SparseImageMemoryRequirements' returned by
-- 'getImageSparseMemoryRequirements'. This /may/ occur when the
-- implementation requires unused padding in the address range describing
-- the resource.
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Device' handle
--
-- -   'Graphics.Vulkan.Core10.Handles.Image' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Image' handle
--
-- -   @pSparseMemoryRequirementCount@ /must/ be a valid pointer to a
--     @uint32_t@ value
--
-- -   If the value referenced by @pSparseMemoryRequirementCount@ is not
--     @0@, and @pSparseMemoryRequirements@ is not @NULL@,
--     @pSparseMemoryRequirements@ /must/ be a valid pointer to an array of
--     @pSparseMemoryRequirementCount@ 'SparseImageMemoryRequirements'
--     structures
--
-- -   'Graphics.Vulkan.Core10.Handles.Image' /must/ have been created,
--     allocated, or retrieved from 'Graphics.Vulkan.Core10.Handles.Device'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.Device',
-- 'Graphics.Vulkan.Core10.Handles.Image', 'SparseImageMemoryRequirements'
getImageSparseMemoryRequirements :: Device -> Image -> IO (("sparseMemoryRequirements" ::: Vector SparseImageMemoryRequirements))
getImageSparseMemoryRequirements device image = evalContT $ do
  let vkGetImageSparseMemoryRequirements' = mkVkGetImageSparseMemoryRequirements (pVkGetImageSparseMemoryRequirements (deviceCmds (device :: Device)))
  let device' = deviceHandle (device)
  pPSparseMemoryRequirementCount <- ContT $ bracket (callocBytes @Word32 4) free
  lift $ vkGetImageSparseMemoryRequirements' device' (image) (pPSparseMemoryRequirementCount) (nullPtr)
  pSparseMemoryRequirementCount <- lift $ peek @Word32 pPSparseMemoryRequirementCount
  pPSparseMemoryRequirements <- ContT $ bracket (callocBytes @SparseImageMemoryRequirements ((fromIntegral (pSparseMemoryRequirementCount)) * 48)) free
  _ <- traverse (\i -> ContT $ pokeZeroCStruct (pPSparseMemoryRequirements `advancePtrBytes` (i * 48) :: Ptr SparseImageMemoryRequirements) . ($ ())) [0..(fromIntegral (pSparseMemoryRequirementCount)) - 1]
  lift $ vkGetImageSparseMemoryRequirements' device' (image) (pPSparseMemoryRequirementCount) ((pPSparseMemoryRequirements))
  pSparseMemoryRequirementCount' <- lift $ peek @Word32 pPSparseMemoryRequirementCount
  pSparseMemoryRequirements' <- lift $ generateM (fromIntegral (pSparseMemoryRequirementCount')) (\i -> peekCStruct @SparseImageMemoryRequirements (((pPSparseMemoryRequirements) `advancePtrBytes` (48 * (i)) :: Ptr SparseImageMemoryRequirements)))
  pure $ (pSparseMemoryRequirements')


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkGetPhysicalDeviceSparseImageFormatProperties
  :: FunPtr (Ptr PhysicalDevice_T -> Format -> ImageType -> SampleCountFlagBits -> ImageUsageFlags -> ImageTiling -> Ptr Word32 -> Ptr SparseImageFormatProperties -> IO ()) -> Ptr PhysicalDevice_T -> Format -> ImageType -> SampleCountFlagBits -> ImageUsageFlags -> ImageTiling -> Ptr Word32 -> Ptr SparseImageFormatProperties -> IO ()

-- | vkGetPhysicalDeviceSparseImageFormatProperties - Retrieve properties of
-- an image format applied to sparse images
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.PhysicalDevice' is the physical
--     device from which to query the sparse image capabilities.
--
-- -   'Graphics.Vulkan.Core10.Enums.Format.Format' is the image format.
--
-- -   @type@ is the dimensionality of image.
--
-- -   @samples@ is the number of samples per texel as defined in
--     'Graphics.Vulkan.Core10.Enums.SampleCountFlagBits.SampleCountFlagBits'.
--
-- -   @usage@ is a bitmask describing the intended usage of the image.
--
-- -   @tiling@ is the tiling arrangement of the texel blocks in memory.
--
-- -   @pPropertyCount@ is a pointer to an integer related to the number of
--     sparse format properties available or queried, as described below.
--
-- -   @pProperties@ is either @NULL@ or a pointer to an array of
--     'SparseImageFormatProperties' structures.
--
-- = Description
--
-- If @pProperties@ is @NULL@, then the number of sparse format properties
-- available is returned in @pPropertyCount@. Otherwise, @pPropertyCount@
-- /must/ point to a variable set by the user to the number of elements in
-- the @pProperties@ array, and on return the variable is overwritten with
-- the number of structures actually written to @pProperties@. If
-- @pPropertyCount@ is less than the number of sparse format properties
-- available, at most @pPropertyCount@ structures will be written.
--
-- If
-- 'Graphics.Vulkan.Core10.Enums.ImageCreateFlagBits.IMAGE_CREATE_SPARSE_RESIDENCY_BIT'
-- is not supported for the given arguments, @pPropertyCount@ will be set
-- to zero upon return, and no data will be written to @pProperties@.
--
-- Multiple aspects are returned for depth\/stencil images that are
-- implemented as separate planes by the implementation. The depth and
-- stencil data planes each have unique 'SparseImageFormatProperties' data.
--
-- Depth\/stencil images with depth and stencil data interleaved into a
-- single plane will return a single 'SparseImageFormatProperties'
-- structure with the @aspectMask@ set to
-- 'Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits.IMAGE_ASPECT_DEPTH_BIT'
-- |
-- 'Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits.IMAGE_ASPECT_STENCIL_BIT'.
--
-- == Valid Usage
--
-- -   @samples@ /must/ be a bit value that is set in
--     'Graphics.Vulkan.Core10.DeviceInitialization.ImageFormatProperties'::@sampleCounts@
--     returned by
--     'Graphics.Vulkan.Core10.DeviceInitialization.getPhysicalDeviceImageFormatProperties'
--     with 'Graphics.Vulkan.Core10.Enums.Format.Format', @type@, @tiling@,
--     and @usage@ equal to those in this command and
--     'Graphics.Vulkan.Core10.BaseType.Flags' equal to the value that is
--     set in
--     'Graphics.Vulkan.Core10.Image.ImageCreateInfo'::'Graphics.Vulkan.Core10.BaseType.Flags'
--     when the image is created
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.PhysicalDevice' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.PhysicalDevice' handle
--
-- -   'Graphics.Vulkan.Core10.Enums.Format.Format' /must/ be a valid
--     'Graphics.Vulkan.Core10.Enums.Format.Format' value
--
-- -   @type@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Enums.ImageType.ImageType' value
--
-- -   @samples@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Enums.SampleCountFlagBits.SampleCountFlagBits'
--     value
--
-- -   @usage@ /must/ be a valid combination of
--     'Graphics.Vulkan.Core10.Enums.ImageUsageFlagBits.ImageUsageFlagBits'
--     values
--
-- -   @usage@ /must/ not be @0@
--
-- -   @tiling@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Enums.ImageTiling.ImageTiling' value
--
-- -   @pPropertyCount@ /must/ be a valid pointer to a @uint32_t@ value
--
-- -   If the value referenced by @pPropertyCount@ is not @0@, and
--     @pProperties@ is not @NULL@, @pProperties@ /must/ be a valid pointer
--     to an array of @pPropertyCount@ 'SparseImageFormatProperties'
--     structures
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Enums.Format.Format',
-- 'Graphics.Vulkan.Core10.Enums.ImageTiling.ImageTiling',
-- 'Graphics.Vulkan.Core10.Enums.ImageType.ImageType',
-- 'Graphics.Vulkan.Core10.Enums.ImageUsageFlagBits.ImageUsageFlags',
-- 'Graphics.Vulkan.Core10.Handles.PhysicalDevice',
-- 'Graphics.Vulkan.Core10.Enums.SampleCountFlagBits.SampleCountFlagBits',
-- 'SparseImageFormatProperties'
getPhysicalDeviceSparseImageFormatProperties :: PhysicalDevice -> Format -> ImageType -> ("samples" ::: SampleCountFlagBits) -> ImageUsageFlags -> ImageTiling -> IO (("properties" ::: Vector SparseImageFormatProperties))
getPhysicalDeviceSparseImageFormatProperties physicalDevice format type' samples usage tiling = evalContT $ do
  let vkGetPhysicalDeviceSparseImageFormatProperties' = mkVkGetPhysicalDeviceSparseImageFormatProperties (pVkGetPhysicalDeviceSparseImageFormatProperties (instanceCmds (physicalDevice :: PhysicalDevice)))
  let physicalDevice' = physicalDeviceHandle (physicalDevice)
  pPPropertyCount <- ContT $ bracket (callocBytes @Word32 4) free
  lift $ vkGetPhysicalDeviceSparseImageFormatProperties' physicalDevice' (format) (type') (samples) (usage) (tiling) (pPPropertyCount) (nullPtr)
  pPropertyCount <- lift $ peek @Word32 pPPropertyCount
  pPProperties <- ContT $ bracket (callocBytes @SparseImageFormatProperties ((fromIntegral (pPropertyCount)) * 20)) free
  _ <- traverse (\i -> ContT $ pokeZeroCStruct (pPProperties `advancePtrBytes` (i * 20) :: Ptr SparseImageFormatProperties) . ($ ())) [0..(fromIntegral (pPropertyCount)) - 1]
  lift $ vkGetPhysicalDeviceSparseImageFormatProperties' physicalDevice' (format) (type') (samples) (usage) (tiling) (pPPropertyCount) ((pPProperties))
  pPropertyCount' <- lift $ peek @Word32 pPPropertyCount
  pProperties' <- lift $ generateM (fromIntegral (pPropertyCount')) (\i -> peekCStruct @SparseImageFormatProperties (((pPProperties) `advancePtrBytes` (20 * (i)) :: Ptr SparseImageFormatProperties)))
  pure $ (pProperties')


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkQueueBindSparse
  :: FunPtr (Ptr Queue_T -> Word32 -> Ptr (BindSparseInfo a) -> Fence -> IO Result) -> Ptr Queue_T -> Word32 -> Ptr (BindSparseInfo a) -> Fence -> IO Result

-- | vkQueueBindSparse - Bind device memory to a sparse resource object
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Queue' is the queue that the sparse
--     binding operations will be submitted to.
--
-- -   @bindInfoCount@ is the number of elements in the @pBindInfo@ array.
--
-- -   @pBindInfo@ is a pointer to an array of 'BindSparseInfo' structures,
--     each specifying a sparse binding submission batch.
--
-- -   'Graphics.Vulkan.Core10.Handles.Fence' is an /optional/ handle to a
--     fence to be signaled. If 'Graphics.Vulkan.Core10.Handles.Fence' is
--     not 'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE', it defines a
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-fences-signaling fence signal operation>.
--
-- = Description
--
-- 'queueBindSparse' is a
-- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#devsandqueues-submission queue submission command>,
-- with each batch defined by an element of @pBindInfo@ as a
-- 'BindSparseInfo' structure. Batches begin execution in the order they
-- appear in @pBindInfo@, but /may/ complete out of order.
--
-- Within a batch, a given range of a resource /must/ not be bound more
-- than once. Across batches, if a range is to be bound to one allocation
-- and offset and then to another allocation and offset, then the
-- application /must/ guarantee (usually using semaphores) that the binding
-- operations are executed in the correct order, as well as to order
-- binding operations against the execution of command buffer submissions.
--
-- As no operation to 'queueBindSparse' causes any pipeline stage to access
-- memory, synchronization primitives used in this command effectively only
-- define execution dependencies.
--
-- Additional information about fence and semaphore operation is described
-- in
-- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization the synchronization chapter>.
--
-- == Valid Usage
--
-- -   If 'Graphics.Vulkan.Core10.Handles.Fence' is not
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE',
--     'Graphics.Vulkan.Core10.Handles.Fence' /must/ be unsignaled
--
-- -   If 'Graphics.Vulkan.Core10.Handles.Fence' is not
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE',
--     'Graphics.Vulkan.Core10.Handles.Fence' /must/ not be associated with
--     any other queue command that has not yet completed execution on that
--     queue
--
-- -   Each element of the @pSignalSemaphores@ member of each element of
--     @pBindInfo@ /must/ be unsignaled when the semaphore signal operation
--     it defines is executed on the device
--
-- -   When a semaphore wait operation referring to a binary semaphore
--     defined by any element of the @pWaitSemaphores@ member of any
--     element of @pBindInfo@ executes on
--     'Graphics.Vulkan.Core10.Handles.Queue', there /must/ be no other
--     queues waiting on the same semaphore.
--
-- -   All elements of the @pWaitSemaphores@ member of all elements of
--     @pBindInfo@ member referring to a binary semaphore /must/ be
--     semaphores that are signaled, or have
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphores-signaling semaphore signal operations>
--     previously submitted for execution.
--
-- -   All elements of the @pWaitSemaphores@ member of all elements of
--     @pBindInfo@ created with a
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SemaphoreType' of
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_BINARY'
--     /must/ reference a semaphore signal operation that has been
--     submitted for execution and any semaphore signal operations on which
--     it depends (if any) /must/ have also been submitted for execution.
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Queue' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Queue' handle
--
-- -   If @bindInfoCount@ is not @0@, @pBindInfo@ /must/ be a valid pointer
--     to an array of @bindInfoCount@ valid 'BindSparseInfo' structures
--
-- -   If 'Graphics.Vulkan.Core10.Handles.Fence' is not
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE',
--     'Graphics.Vulkan.Core10.Handles.Fence' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Fence' handle
--
-- -   The 'Graphics.Vulkan.Core10.Handles.Queue' /must/ support sparse
--     binding operations
--
-- -   Both of 'Graphics.Vulkan.Core10.Handles.Fence', and
--     'Graphics.Vulkan.Core10.Handles.Queue' that are valid handles of
--     non-ignored parameters /must/ have been created, allocated, or
--     retrieved from the same 'Graphics.Vulkan.Core10.Handles.Device'
--
-- == Host Synchronization
--
-- -   Host access to 'Graphics.Vulkan.Core10.Handles.Queue' /must/ be
--     externally synchronized
--
-- -   Host access to @pBindInfo@[].pBufferBinds[].buffer /must/ be
--     externally synchronized
--
-- -   Host access to @pBindInfo@[].pImageOpaqueBinds[].image /must/ be
--     externally synchronized
--
-- -   Host access to @pBindInfo@[].pImageBinds[].image /must/ be
--     externally synchronized
--
-- -   Host access to 'Graphics.Vulkan.Core10.Handles.Fence' /must/ be
--     externally synchronized
--
-- == Command Properties
--
-- \'
--
-- +----------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
-- | <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#VkCommandBufferLevel Command Buffer Levels> | <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#vkCmdBeginRenderPass Render Pass Scope> | <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#VkQueueFlagBits Supported Queue Types> | <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-pipeline-stages-types Pipeline Type> |
-- +============================================================================================================================+========================================================================================================================+=======================================================================================================================+=====================================================================================================================================+
-- | -                                                                                                                          | -                                                                                                                      | SPARSE_BINDING                                                                                                        | -                                                                                                                                   |
-- +----------------------------------------------------------------------------------------------------------------------------+------------------------------------------------------------------------------------------------------------------------+-----------------------------------------------------------------------------------------------------------------------+-------------------------------------------------------------------------------------------------------------------------------------+
--
-- == Return Codes
--
-- [<https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#fundamentals-successcodes Success>]
--
--     -   'Graphics.Vulkan.Core10.Enums.Result.SUCCESS'
--
-- [<https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#fundamentals-errorcodes Failure>]
--
--     -   'Graphics.Vulkan.Core10.Enums.Result.ERROR_OUT_OF_HOST_MEMORY'
--
--     -   'Graphics.Vulkan.Core10.Enums.Result.ERROR_OUT_OF_DEVICE_MEMORY'
--
--     -   'Graphics.Vulkan.Core10.Enums.Result.ERROR_DEVICE_LOST'
--
-- = See Also
--
-- 'BindSparseInfo', 'Graphics.Vulkan.Core10.Handles.Fence',
-- 'Graphics.Vulkan.Core10.Handles.Queue'
queueBindSparse :: PokeChain a => Queue -> ("bindInfo" ::: Vector (BindSparseInfo a)) -> Fence -> IO ()
queueBindSparse queue bindInfo fence = evalContT $ do
  let vkQueueBindSparse' = mkVkQueueBindSparse (pVkQueueBindSparse (deviceCmds (queue :: Queue)))
  pPBindInfo <- ContT $ allocaBytesAligned @(BindSparseInfo _) ((Data.Vector.length (bindInfo)) * 96) 8
  Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBindInfo `plusPtr` (96 * (i)) :: Ptr (BindSparseInfo _)) (e) . ($ ())) (bindInfo)
  r <- lift $ vkQueueBindSparse' (queueHandle (queue)) ((fromIntegral (Data.Vector.length $ (bindInfo)) :: Word32)) (pPBindInfo) (fence)
  lift $ when (r < SUCCESS) (throwIO (VulkanException r))


-- | VkSparseImageFormatProperties - Structure specifying sparse image format
-- properties
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.SharedTypes.Extent3D',
-- 'Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits.ImageAspectFlags',
-- 'Graphics.Vulkan.Core10.Enums.SparseImageFormatFlagBits.SparseImageFormatFlags',
-- 'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_get_physical_device_properties2.SparseImageFormatProperties2',
-- 'SparseImageMemoryRequirements',
-- 'getPhysicalDeviceSparseImageFormatProperties'
data SparseImageFormatProperties = SparseImageFormatProperties
  { -- | @aspectMask@ is a bitmask
    -- 'Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits.ImageAspectFlagBits'
    -- specifying which aspects of the image the properties apply to.
    aspectMask :: ImageAspectFlags
  , -- | @imageGranularity@ is the width, height, and depth of the sparse image
    -- block in texels or compressed texel blocks.
    imageGranularity :: Extent3D
  , -- | 'Graphics.Vulkan.Core10.BaseType.Flags' is a bitmask of
    -- 'Graphics.Vulkan.Core10.Enums.SparseImageFormatFlagBits.SparseImageFormatFlagBits'
    -- specifying additional information about the sparse resource.
    flags :: SparseImageFormatFlags
  }
  deriving (Typeable)
deriving instance Show SparseImageFormatProperties

instance ToCStruct SparseImageFormatProperties where
  withCStruct x f = allocaBytesAligned 20 4 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p SparseImageFormatProperties{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr ImageAspectFlags)) (aspectMask)
    ContT $ pokeCStruct ((p `plusPtr` 4 :: Ptr Extent3D)) (imageGranularity) . ($ ())
    lift $ poke ((p `plusPtr` 16 :: Ptr SparseImageFormatFlags)) (flags)
    lift $ f
  cStructSize = 20
  cStructAlignment = 4
  pokeZeroCStruct p f = evalContT $ do
    ContT $ pokeCStruct ((p `plusPtr` 4 :: Ptr Extent3D)) (zero) . ($ ())
    lift $ f

instance FromCStruct SparseImageFormatProperties where
  peekCStruct p = do
    aspectMask <- peek @ImageAspectFlags ((p `plusPtr` 0 :: Ptr ImageAspectFlags))
    imageGranularity <- peekCStruct @Extent3D ((p `plusPtr` 4 :: Ptr Extent3D))
    flags <- peek @SparseImageFormatFlags ((p `plusPtr` 16 :: Ptr SparseImageFormatFlags))
    pure $ SparseImageFormatProperties
             aspectMask imageGranularity flags

instance Zero SparseImageFormatProperties where
  zero = SparseImageFormatProperties
           zero
           zero
           zero


-- | VkSparseImageMemoryRequirements - Structure specifying sparse image
-- memory requirements
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.BaseType.DeviceSize',
-- 'SparseImageFormatProperties',
-- 'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_get_memory_requirements2.SparseImageMemoryRequirements2',
-- 'getImageSparseMemoryRequirements'
data SparseImageMemoryRequirements = SparseImageMemoryRequirements
  { -- No documentation found for Nested "VkSparseImageMemoryRequirements" "formatProperties"
    formatProperties :: SparseImageFormatProperties
  , -- | @imageMipTailFirstLod@ is the first mip level at which image
    -- subresources are included in the mip tail region.
    imageMipTailFirstLod :: Word32
  , -- | @imageMipTailSize@ is the memory size (in bytes) of the mip tail region.
    -- If @formatProperties.flags@ contains
    -- 'Graphics.Vulkan.Core10.Enums.SparseImageFormatFlagBits.SPARSE_IMAGE_FORMAT_SINGLE_MIPTAIL_BIT',
    -- this is the size of the whole mip tail, otherwise this is the size of
    -- the mip tail of a single array layer. This value is guaranteed to be a
    -- multiple of the sparse block size in bytes.
    imageMipTailSize :: DeviceSize
  , -- | @imageMipTailOffset@ is the opaque memory offset used with
    -- 'SparseImageOpaqueMemoryBindInfo' to bind the mip tail region(s).
    imageMipTailOffset :: DeviceSize
  , -- | @imageMipTailStride@ is the offset stride between each array-layer’s mip
    -- tail, if @formatProperties.flags@ does not contain
    -- 'Graphics.Vulkan.Core10.Enums.SparseImageFormatFlagBits.SPARSE_IMAGE_FORMAT_SINGLE_MIPTAIL_BIT'
    -- (otherwise the value is undefined).
    imageMipTailStride :: DeviceSize
  }
  deriving (Typeable)
deriving instance Show SparseImageMemoryRequirements

instance ToCStruct SparseImageMemoryRequirements where
  withCStruct x f = allocaBytesAligned 48 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p SparseImageMemoryRequirements{..} f = evalContT $ do
    ContT $ pokeCStruct ((p `plusPtr` 0 :: Ptr SparseImageFormatProperties)) (formatProperties) . ($ ())
    lift $ poke ((p `plusPtr` 20 :: Ptr Word32)) (imageMipTailFirstLod)
    lift $ poke ((p `plusPtr` 24 :: Ptr DeviceSize)) (imageMipTailSize)
    lift $ poke ((p `plusPtr` 32 :: Ptr DeviceSize)) (imageMipTailOffset)
    lift $ poke ((p `plusPtr` 40 :: Ptr DeviceSize)) (imageMipTailStride)
    lift $ f
  cStructSize = 48
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    ContT $ pokeCStruct ((p `plusPtr` 0 :: Ptr SparseImageFormatProperties)) (zero) . ($ ())
    lift $ poke ((p `plusPtr` 20 :: Ptr Word32)) (zero)
    lift $ poke ((p `plusPtr` 24 :: Ptr DeviceSize)) (zero)
    lift $ poke ((p `plusPtr` 32 :: Ptr DeviceSize)) (zero)
    lift $ poke ((p `plusPtr` 40 :: Ptr DeviceSize)) (zero)
    lift $ f

instance FromCStruct SparseImageMemoryRequirements where
  peekCStruct p = do
    formatProperties <- peekCStruct @SparseImageFormatProperties ((p `plusPtr` 0 :: Ptr SparseImageFormatProperties))
    imageMipTailFirstLod <- peek @Word32 ((p `plusPtr` 20 :: Ptr Word32))
    imageMipTailSize <- peek @DeviceSize ((p `plusPtr` 24 :: Ptr DeviceSize))
    imageMipTailOffset <- peek @DeviceSize ((p `plusPtr` 32 :: Ptr DeviceSize))
    imageMipTailStride <- peek @DeviceSize ((p `plusPtr` 40 :: Ptr DeviceSize))
    pure $ SparseImageMemoryRequirements
             formatProperties imageMipTailFirstLod imageMipTailSize imageMipTailOffset imageMipTailStride

instance Zero SparseImageMemoryRequirements where
  zero = SparseImageMemoryRequirements
           zero
           zero
           zero
           zero
           zero


-- | VkSparseMemoryBind - Structure specifying a sparse memory bind operation
--
-- = Description
--
-- The /binding range/ [@resourceOffset@, @resourceOffset@ + @size@) has
-- different constraints based on 'Graphics.Vulkan.Core10.BaseType.Flags'.
-- If 'Graphics.Vulkan.Core10.BaseType.Flags' contains
-- 'Graphics.Vulkan.Core10.Enums.SparseMemoryBindFlagBits.SPARSE_MEMORY_BIND_METADATA_BIT',
-- the binding range /must/ be within the mip tail region of the metadata
-- aspect. This metadata region is defined by:
--
-- -   metadataRegion = [base, base + @imageMipTailSize@)
--
-- -   base = @imageMipTailOffset@ + @imageMipTailStride@ × n
--
-- and @imageMipTailOffset@, @imageMipTailSize@, and @imageMipTailStride@
-- values are from the 'SparseImageMemoryRequirements' corresponding to the
-- metadata aspect of the image, and n is a valid array layer index for the
-- image,
--
-- @imageMipTailStride@ is considered to be zero for aspects where
-- 'SparseImageMemoryRequirements'::@formatProperties.flags@ contains
-- 'Graphics.Vulkan.Core10.Enums.SparseImageFormatFlagBits.SPARSE_IMAGE_FORMAT_SINGLE_MIPTAIL_BIT'.
--
-- If 'Graphics.Vulkan.Core10.BaseType.Flags' does not contain
-- 'Graphics.Vulkan.Core10.Enums.SparseMemoryBindFlagBits.SPARSE_MEMORY_BIND_METADATA_BIT',
-- the binding range /must/ be within the range
-- [0,'Graphics.Vulkan.Core10.MemoryManagement.MemoryRequirements'::@size@).
--
-- == Valid Usage
--
-- -   If @memory@ is not
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE', @memory@ and
--     @memoryOffset@ /must/ match the memory requirements of the resource,
--     as described in section
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#resources-association>
--
-- -   If @memory@ is not
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE', @memory@ /must/
--     not have been created with a memory type that reports
--     'Graphics.Vulkan.Core10.Enums.MemoryPropertyFlagBits.MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT'
--     bit set
--
-- -   @size@ /must/ be greater than @0@
--
-- -   @resourceOffset@ /must/ be less than the size of the resource
--
-- -   @size@ /must/ be less than or equal to the size of the resource
--     minus @resourceOffset@
--
-- -   @memoryOffset@ /must/ be less than the size of @memory@
--
-- -   @size@ /must/ be less than or equal to the size of @memory@ minus
--     @memoryOffset@
--
-- -   If @memory@ was created with
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_external_memory.ExportMemoryAllocateInfo'::@handleTypes@
--     not equal to @0@, at least one handle type it contained /must/ also
--     have been set in
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_external_memory.ExternalMemoryBufferCreateInfo'::@handleTypes@
--     or
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_external_memory.ExternalMemoryImageCreateInfo'::@handleTypes@
--     when the resource was created.
--
-- -   If @memory@ was created by a memory import operation, the external
--     handle type of the imported memory /must/ also have been set in
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_external_memory.ExternalMemoryBufferCreateInfo'::@handleTypes@
--     or
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_external_memory.ExternalMemoryImageCreateInfo'::@handleTypes@
--     when the resource was created.
--
-- == Valid Usage (Implicit)
--
-- -   If @memory@ is not
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE', @memory@ /must/
--     be a valid 'Graphics.Vulkan.Core10.Handles.DeviceMemory' handle
--
-- -   'Graphics.Vulkan.Core10.BaseType.Flags' /must/ be a valid
--     combination of
--     'Graphics.Vulkan.Core10.Enums.SparseMemoryBindFlagBits.SparseMemoryBindFlagBits'
--     values
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.DeviceMemory',
-- 'Graphics.Vulkan.Core10.BaseType.DeviceSize',
-- 'SparseBufferMemoryBindInfo', 'SparseImageOpaqueMemoryBindInfo',
-- 'Graphics.Vulkan.Core10.Enums.SparseMemoryBindFlagBits.SparseMemoryBindFlags'
data SparseMemoryBind = SparseMemoryBind
  { -- | @resourceOffset@ is the offset into the resource.
    resourceOffset :: DeviceSize
  , -- | @size@ is the size of the memory region to be bound.
    size :: DeviceSize
  , -- | @memory@ is the 'Graphics.Vulkan.Core10.Handles.DeviceMemory' object
    -- that the range of the resource is bound to. If @memory@ is
    -- 'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE', the range is unbound.
    memory :: DeviceMemory
  , -- | @memoryOffset@ is the offset into the
    -- 'Graphics.Vulkan.Core10.Handles.DeviceMemory' object to bind the
    -- resource range to. If @memory@ is
    -- 'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE', this value is
    -- ignored.
    memoryOffset :: DeviceSize
  , -- | 'Graphics.Vulkan.Core10.BaseType.Flags' is a bitmask of
    -- 'Graphics.Vulkan.Core10.Enums.SparseMemoryBindFlagBits.SparseMemoryBindFlagBits'
    -- specifying usage of the binding operation.
    flags :: SparseMemoryBindFlags
  }
  deriving (Typeable)
deriving instance Show SparseMemoryBind

instance ToCStruct SparseMemoryBind where
  withCStruct x f = allocaBytesAligned 40 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p SparseMemoryBind{..} f = do
    poke ((p `plusPtr` 0 :: Ptr DeviceSize)) (resourceOffset)
    poke ((p `plusPtr` 8 :: Ptr DeviceSize)) (size)
    poke ((p `plusPtr` 16 :: Ptr DeviceMemory)) (memory)
    poke ((p `plusPtr` 24 :: Ptr DeviceSize)) (memoryOffset)
    poke ((p `plusPtr` 32 :: Ptr SparseMemoryBindFlags)) (flags)
    f
  cStructSize = 40
  cStructAlignment = 8
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr DeviceSize)) (zero)
    poke ((p `plusPtr` 8 :: Ptr DeviceSize)) (zero)
    poke ((p `plusPtr` 24 :: Ptr DeviceSize)) (zero)
    f

instance FromCStruct SparseMemoryBind where
  peekCStruct p = do
    resourceOffset <- peek @DeviceSize ((p `plusPtr` 0 :: Ptr DeviceSize))
    size <- peek @DeviceSize ((p `plusPtr` 8 :: Ptr DeviceSize))
    memory <- peek @DeviceMemory ((p `plusPtr` 16 :: Ptr DeviceMemory))
    memoryOffset <- peek @DeviceSize ((p `plusPtr` 24 :: Ptr DeviceSize))
    flags <- peek @SparseMemoryBindFlags ((p `plusPtr` 32 :: Ptr SparseMemoryBindFlags))
    pure $ SparseMemoryBind
             resourceOffset size memory memoryOffset flags

instance Storable SparseMemoryBind where
  sizeOf ~_ = 40
  alignment ~_ = 8
  peek = peekCStruct
  poke ptr poked = pokeCStruct ptr poked (pure ())

instance Zero SparseMemoryBind where
  zero = SparseMemoryBind
           zero
           zero
           zero
           zero
           zero


-- | VkSparseImageMemoryBind - Structure specifying sparse image memory bind
--
-- == Valid Usage
--
-- -   If the
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#features-sparseResidencyAliased sparse aliased residency>
--     feature is not enabled, and if any other resources are bound to
--     ranges of @memory@, the range of @memory@ being bound /must/ not
--     overlap with those bound ranges
--
-- -   @memory@ and @memoryOffset@ /must/ match the memory requirements of
--     the calling command’s 'Graphics.Vulkan.Core10.Handles.Image', as
--     described in section
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#resources-association>
--
-- -   @subresource@ /must/ be a valid image subresource for
--     'Graphics.Vulkan.Core10.Handles.Image' (see
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#resources-image-views>)
--
-- -   @offset.x@ /must/ be a multiple of the sparse image block width
--     ('SparseImageFormatProperties'::@imageGranularity.width@) of the
--     image
--
-- -   @extent.width@ /must/ either be a multiple of the sparse image block
--     width of the image, or else (@extent.width@ + @offset.x@) /must/
--     equal the width of the image subresource
--
-- -   @offset.y@ /must/ be a multiple of the sparse image block height
--     ('SparseImageFormatProperties'::@imageGranularity.height@) of the
--     image
--
-- -   @extent.height@ /must/ either be a multiple of the sparse image
--     block height of the image, or else (@extent.height@ + @offset.y@)
--     /must/ equal the height of the image subresource
--
-- -   @offset.z@ /must/ be a multiple of the sparse image block depth
--     ('SparseImageFormatProperties'::@imageGranularity.depth@) of the
--     image
--
-- -   @extent.depth@ /must/ either be a multiple of the sparse image block
--     depth of the image, or else (@extent.depth@ + @offset.z@) /must/
--     equal the depth of the image subresource
--
-- -   If @memory@ was created with
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_external_memory.ExportMemoryAllocateInfo'::@handleTypes@
--     not equal to @0@, at least one handle type it contained /must/ also
--     have been set in
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_external_memory.ExternalMemoryImageCreateInfo'::@handleTypes@
--     when the image was created.
--
-- -   If @memory@ was created by a memory import operation, the external
--     handle type of the imported memory /must/ also have been set in
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_external_memory.ExternalMemoryImageCreateInfo'::@handleTypes@
--     when 'Graphics.Vulkan.Core10.Handles.Image' was created.
--
-- == Valid Usage (Implicit)
--
-- -   @subresource@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Image.ImageSubresource' structure
--
-- -   If @memory@ is not
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE', @memory@ /must/
--     be a valid 'Graphics.Vulkan.Core10.Handles.DeviceMemory' handle
--
-- -   'Graphics.Vulkan.Core10.BaseType.Flags' /must/ be a valid
--     combination of
--     'Graphics.Vulkan.Core10.Enums.SparseMemoryBindFlagBits.SparseMemoryBindFlagBits'
--     values
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.DeviceMemory',
-- 'Graphics.Vulkan.Core10.BaseType.DeviceSize',
-- 'Graphics.Vulkan.Core10.SharedTypes.Extent3D',
-- 'Graphics.Vulkan.Core10.Image.ImageSubresource',
-- 'Graphics.Vulkan.Core10.SharedTypes.Offset3D',
-- 'SparseImageMemoryBindInfo',
-- 'Graphics.Vulkan.Core10.Enums.SparseMemoryBindFlagBits.SparseMemoryBindFlags'
data SparseImageMemoryBind = SparseImageMemoryBind
  { -- | @subresource@ is the image /aspect/ and region of interest in the image.
    subresource :: ImageSubresource
  , -- | @offset@ are the coordinates of the first texel within the image
    -- subresource to bind.
    offset :: Offset3D
  , -- | @extent@ is the size in texels of the region within the image
    -- subresource to bind. The extent /must/ be a multiple of the sparse image
    -- block dimensions, except when binding sparse image blocks along the edge
    -- of an image subresource it /can/ instead be such that any coordinate of
    -- @offset@ + @extent@ equals the corresponding dimensions of the image
    -- subresource.
    extent :: Extent3D
  , -- | @memory@ is the 'Graphics.Vulkan.Core10.Handles.DeviceMemory' object
    -- that the sparse image blocks of the image are bound to. If @memory@ is
    -- 'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE', the sparse image
    -- blocks are unbound.
    memory :: DeviceMemory
  , -- | @memoryOffset@ is an offset into
    -- 'Graphics.Vulkan.Core10.Handles.DeviceMemory' object. If @memory@ is
    -- 'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE', this value is
    -- ignored.
    memoryOffset :: DeviceSize
  , -- | 'Graphics.Vulkan.Core10.BaseType.Flags' are sparse memory binding flags.
    flags :: SparseMemoryBindFlags
  }
  deriving (Typeable)
deriving instance Show SparseImageMemoryBind

instance ToCStruct SparseImageMemoryBind where
  withCStruct x f = allocaBytesAligned 64 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p SparseImageMemoryBind{..} f = evalContT $ do
    ContT $ pokeCStruct ((p `plusPtr` 0 :: Ptr ImageSubresource)) (subresource) . ($ ())
    ContT $ pokeCStruct ((p `plusPtr` 12 :: Ptr Offset3D)) (offset) . ($ ())
    ContT $ pokeCStruct ((p `plusPtr` 24 :: Ptr Extent3D)) (extent) . ($ ())
    lift $ poke ((p `plusPtr` 40 :: Ptr DeviceMemory)) (memory)
    lift $ poke ((p `plusPtr` 48 :: Ptr DeviceSize)) (memoryOffset)
    lift $ poke ((p `plusPtr` 56 :: Ptr SparseMemoryBindFlags)) (flags)
    lift $ f
  cStructSize = 64
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    ContT $ pokeCStruct ((p `plusPtr` 0 :: Ptr ImageSubresource)) (zero) . ($ ())
    ContT $ pokeCStruct ((p `plusPtr` 12 :: Ptr Offset3D)) (zero) . ($ ())
    ContT $ pokeCStruct ((p `plusPtr` 24 :: Ptr Extent3D)) (zero) . ($ ())
    lift $ poke ((p `plusPtr` 48 :: Ptr DeviceSize)) (zero)
    lift $ f

instance FromCStruct SparseImageMemoryBind where
  peekCStruct p = do
    subresource <- peekCStruct @ImageSubresource ((p `plusPtr` 0 :: Ptr ImageSubresource))
    offset <- peekCStruct @Offset3D ((p `plusPtr` 12 :: Ptr Offset3D))
    extent <- peekCStruct @Extent3D ((p `plusPtr` 24 :: Ptr Extent3D))
    memory <- peek @DeviceMemory ((p `plusPtr` 40 :: Ptr DeviceMemory))
    memoryOffset <- peek @DeviceSize ((p `plusPtr` 48 :: Ptr DeviceSize))
    flags <- peek @SparseMemoryBindFlags ((p `plusPtr` 56 :: Ptr SparseMemoryBindFlags))
    pure $ SparseImageMemoryBind
             subresource offset extent memory memoryOffset flags

instance Zero SparseImageMemoryBind where
  zero = SparseImageMemoryBind
           zero
           zero
           zero
           zero
           zero
           zero


-- | VkSparseBufferMemoryBindInfo - Structure specifying a sparse buffer
-- memory bind operation
--
-- == Valid Usage (Implicit)
--
-- = See Also
--
-- 'BindSparseInfo', 'Graphics.Vulkan.Core10.Handles.Buffer',
-- 'SparseMemoryBind'
data SparseBufferMemoryBindInfo = SparseBufferMemoryBindInfo
  { -- | 'Graphics.Vulkan.Core10.Handles.Buffer' /must/ be a valid
    -- 'Graphics.Vulkan.Core10.Handles.Buffer' handle
    buffer :: Buffer
  , -- | @pBinds@ /must/ be a valid pointer to an array of @bindCount@ valid
    -- 'SparseMemoryBind' structures
    binds :: Vector SparseMemoryBind
  }
  deriving (Typeable)
deriving instance Show SparseBufferMemoryBindInfo

instance ToCStruct SparseBufferMemoryBindInfo where
  withCStruct x f = allocaBytesAligned 24 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p SparseBufferMemoryBindInfo{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr Buffer)) (buffer)
    lift $ poke ((p `plusPtr` 8 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (binds)) :: Word32))
    pPBinds' <- ContT $ allocaBytesAligned @SparseMemoryBind ((Data.Vector.length (binds)) * 40) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBinds' `plusPtr` (40 * (i)) :: Ptr SparseMemoryBind) (e) . ($ ())) (binds)
    lift $ poke ((p `plusPtr` 16 :: Ptr (Ptr SparseMemoryBind))) (pPBinds')
    lift $ f
  cStructSize = 24
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr Buffer)) (zero)
    pPBinds' <- ContT $ allocaBytesAligned @SparseMemoryBind ((Data.Vector.length (mempty)) * 40) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBinds' `plusPtr` (40 * (i)) :: Ptr SparseMemoryBind) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 16 :: Ptr (Ptr SparseMemoryBind))) (pPBinds')
    lift $ f

instance FromCStruct SparseBufferMemoryBindInfo where
  peekCStruct p = do
    buffer <- peek @Buffer ((p `plusPtr` 0 :: Ptr Buffer))
    bindCount <- peek @Word32 ((p `plusPtr` 8 :: Ptr Word32))
    pBinds <- peek @(Ptr SparseMemoryBind) ((p `plusPtr` 16 :: Ptr (Ptr SparseMemoryBind)))
    pBinds' <- generateM (fromIntegral bindCount) (\i -> peekCStruct @SparseMemoryBind ((pBinds `advancePtrBytes` (40 * (i)) :: Ptr SparseMemoryBind)))
    pure $ SparseBufferMemoryBindInfo
             buffer pBinds'

instance Zero SparseBufferMemoryBindInfo where
  zero = SparseBufferMemoryBindInfo
           zero
           mempty


-- | VkSparseImageOpaqueMemoryBindInfo - Structure specifying sparse image
-- opaque memory bind info
--
-- == Valid Usage
--
-- -   If the 'Graphics.Vulkan.Core10.BaseType.Flags' member of any element
--     of @pBinds@ contains
--     'Graphics.Vulkan.Core10.Enums.SparseMemoryBindFlagBits.SPARSE_MEMORY_BIND_METADATA_BIT',
--     the binding range defined /must/ be within the mip tail region of
--     the metadata aspect of 'Graphics.Vulkan.Core10.Handles.Image'
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Image' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Image' handle
--
-- -   @pBinds@ /must/ be a valid pointer to an array of @bindCount@ valid
--     'SparseMemoryBind' structures
--
-- -   @bindCount@ /must/ be greater than @0@
--
-- = See Also
--
-- 'BindSparseInfo', 'Graphics.Vulkan.Core10.Handles.Image',
-- 'SparseMemoryBind'
data SparseImageOpaqueMemoryBindInfo = SparseImageOpaqueMemoryBindInfo
  { -- | 'Graphics.Vulkan.Core10.Handles.Image' is the
    -- 'Graphics.Vulkan.Core10.Handles.Image' object to be bound.
    image :: Image
  , -- | @pBinds@ is a pointer to an array of 'SparseMemoryBind' structures.
    binds :: Vector SparseMemoryBind
  }
  deriving (Typeable)
deriving instance Show SparseImageOpaqueMemoryBindInfo

instance ToCStruct SparseImageOpaqueMemoryBindInfo where
  withCStruct x f = allocaBytesAligned 24 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p SparseImageOpaqueMemoryBindInfo{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr Image)) (image)
    lift $ poke ((p `plusPtr` 8 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (binds)) :: Word32))
    pPBinds' <- ContT $ allocaBytesAligned @SparseMemoryBind ((Data.Vector.length (binds)) * 40) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBinds' `plusPtr` (40 * (i)) :: Ptr SparseMemoryBind) (e) . ($ ())) (binds)
    lift $ poke ((p `plusPtr` 16 :: Ptr (Ptr SparseMemoryBind))) (pPBinds')
    lift $ f
  cStructSize = 24
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr Image)) (zero)
    pPBinds' <- ContT $ allocaBytesAligned @SparseMemoryBind ((Data.Vector.length (mempty)) * 40) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBinds' `plusPtr` (40 * (i)) :: Ptr SparseMemoryBind) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 16 :: Ptr (Ptr SparseMemoryBind))) (pPBinds')
    lift $ f

instance FromCStruct SparseImageOpaqueMemoryBindInfo where
  peekCStruct p = do
    image <- peek @Image ((p `plusPtr` 0 :: Ptr Image))
    bindCount <- peek @Word32 ((p `plusPtr` 8 :: Ptr Word32))
    pBinds <- peek @(Ptr SparseMemoryBind) ((p `plusPtr` 16 :: Ptr (Ptr SparseMemoryBind)))
    pBinds' <- generateM (fromIntegral bindCount) (\i -> peekCStruct @SparseMemoryBind ((pBinds `advancePtrBytes` (40 * (i)) :: Ptr SparseMemoryBind)))
    pure $ SparseImageOpaqueMemoryBindInfo
             image pBinds'

instance Zero SparseImageOpaqueMemoryBindInfo where
  zero = SparseImageOpaqueMemoryBindInfo
           zero
           mempty


-- | VkSparseImageMemoryBindInfo - Structure specifying sparse image memory
-- bind info
--
-- == Valid Usage
--
-- -   The @subresource.mipLevel@ member of each element of @pBinds@ /must/
--     be less than the @mipLevels@ specified in
--     'Graphics.Vulkan.Core10.Image.ImageCreateInfo' when
--     'Graphics.Vulkan.Core10.Handles.Image' was created
--
-- -   The @subresource.arrayLayer@ member of each element of @pBinds@
--     /must/ be less than the @arrayLayers@ specified in
--     'Graphics.Vulkan.Core10.Image.ImageCreateInfo' when
--     'Graphics.Vulkan.Core10.Handles.Image' was created
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Image' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Image' handle
--
-- -   @pBinds@ /must/ be a valid pointer to an array of @bindCount@ valid
--     'SparseImageMemoryBind' structures
--
-- -   @bindCount@ /must/ be greater than @0@
--
-- = See Also
--
-- 'BindSparseInfo', 'Graphics.Vulkan.Core10.Handles.Image',
-- 'SparseImageMemoryBind'
data SparseImageMemoryBindInfo = SparseImageMemoryBindInfo
  { -- | 'Graphics.Vulkan.Core10.Handles.Image' is the
    -- 'Graphics.Vulkan.Core10.Handles.Image' object to be bound
    image :: Image
  , -- | @pBinds@ is a pointer to an array of 'SparseImageMemoryBind' structures
    binds :: Vector SparseImageMemoryBind
  }
  deriving (Typeable)
deriving instance Show SparseImageMemoryBindInfo

instance ToCStruct SparseImageMemoryBindInfo where
  withCStruct x f = allocaBytesAligned 24 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p SparseImageMemoryBindInfo{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr Image)) (image)
    lift $ poke ((p `plusPtr` 8 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (binds)) :: Word32))
    pPBinds' <- ContT $ allocaBytesAligned @SparseImageMemoryBind ((Data.Vector.length (binds)) * 64) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBinds' `plusPtr` (64 * (i)) :: Ptr SparseImageMemoryBind) (e) . ($ ())) (binds)
    lift $ poke ((p `plusPtr` 16 :: Ptr (Ptr SparseImageMemoryBind))) (pPBinds')
    lift $ f
  cStructSize = 24
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr Image)) (zero)
    pPBinds' <- ContT $ allocaBytesAligned @SparseImageMemoryBind ((Data.Vector.length (mempty)) * 64) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBinds' `plusPtr` (64 * (i)) :: Ptr SparseImageMemoryBind) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 16 :: Ptr (Ptr SparseImageMemoryBind))) (pPBinds')
    lift $ f

instance FromCStruct SparseImageMemoryBindInfo where
  peekCStruct p = do
    image <- peek @Image ((p `plusPtr` 0 :: Ptr Image))
    bindCount <- peek @Word32 ((p `plusPtr` 8 :: Ptr Word32))
    pBinds <- peek @(Ptr SparseImageMemoryBind) ((p `plusPtr` 16 :: Ptr (Ptr SparseImageMemoryBind)))
    pBinds' <- generateM (fromIntegral bindCount) (\i -> peekCStruct @SparseImageMemoryBind ((pBinds `advancePtrBytes` (64 * (i)) :: Ptr SparseImageMemoryBind)))
    pure $ SparseImageMemoryBindInfo
             image pBinds'

instance Zero SparseImageMemoryBindInfo where
  zero = SparseImageMemoryBindInfo
           zero
           mempty


-- | VkBindSparseInfo - Structure specifying a sparse binding operation
--
-- == Valid Usage
--
-- -   If any element of @pWaitSemaphores@ or @pSignalSemaphores@ was
--     created with a
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SemaphoreType' of
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_TIMELINE'
--     then the @pNext@ chain /must/ include a
--     'Graphics.Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.TimelineSemaphoreSubmitInfo'
--     structure
--
-- -   If the @pNext@ chain of this structure includes a
--     'Graphics.Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.TimelineSemaphoreSubmitInfo'
--     structure and any element of @pWaitSemaphores@ was created with a
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SemaphoreType' of
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_TIMELINE'
--     then its @waitSemaphoreValueCount@ member /must/ equal
--     @waitSemaphoreCount@
--
-- -   If the @pNext@ chain of this structure includes a
--     'Graphics.Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.TimelineSemaphoreSubmitInfo'
--     structure and any element of @pSignalSemaphores@ was created with a
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SemaphoreType' of
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_TIMELINE'
--     then its @signalSemaphoreValueCount@ member /must/ equal
--     @signalSemaphoreCount@
--
-- -   For each element of @pSignalSemaphores@ created with a
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SemaphoreType' of
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_TIMELINE'
--     the corresponding element of
--     'Graphics.Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.TimelineSemaphoreSubmitInfo'::pSignalSemaphoreValues
--     /must/ have a value greater than the current value of the semaphore
--     when the
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphores-signaling semaphore signal operation>
--     is executed
--
-- -   For each element of @pWaitSemaphores@ created with a
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SemaphoreType' of
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_TIMELINE'
--     the corresponding element of
--     'Graphics.Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.TimelineSemaphoreSubmitInfo'::pWaitSemaphoreValues
--     /must/ have a value which does not differ from the current value of
--     the semaphore or from the value of any outstanding semaphore wait or
--     signal operation on that semaphore by more than
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#limits-maxTimelineSemaphoreValueDifference maxTimelineSemaphoreValueDifference>.
--
-- -   For each element of @pSignalSemaphores@ created with a
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SemaphoreType' of
--     'Graphics.Vulkan.Core12.Enums.SemaphoreType.SEMAPHORE_TYPE_TIMELINE'
--     the corresponding element of
--     'Graphics.Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.TimelineSemaphoreSubmitInfo'::pSignalSemaphoreValues
--     /must/ have a value which does not differ from the current value of
--     the semaphore or from the value of any outstanding semaphore wait or
--     signal operation on that semaphore by more than
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#limits-maxTimelineSemaphoreValueDifference maxTimelineSemaphoreValueDifference>.
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Graphics.Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_BIND_SPARSE_INFO'
--
-- -   Each @pNext@ member of any structure (including this one) in the
--     @pNext@ chain /must/ be either @NULL@ or a pointer to a valid
--     instance of
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_device_group.DeviceGroupBindSparseInfo'
--     or
--     'Graphics.Vulkan.Core12.Promoted_From_VK_KHR_timeline_semaphore.TimelineSemaphoreSubmitInfo'
--
-- -   The @sType@ value of each struct in the @pNext@ chain /must/ be
--     unique
--
-- -   If @waitSemaphoreCount@ is not @0@, @pWaitSemaphores@ /must/ be a
--     valid pointer to an array of @waitSemaphoreCount@ valid
--     'Graphics.Vulkan.Core10.Handles.Semaphore' handles
--
-- -   If @bufferBindCount@ is not @0@, @pBufferBinds@ /must/ be a valid
--     pointer to an array of @bufferBindCount@ valid
--     'SparseBufferMemoryBindInfo' structures
--
-- -   If @imageOpaqueBindCount@ is not @0@, @pImageOpaqueBinds@ /must/ be
--     a valid pointer to an array of @imageOpaqueBindCount@ valid
--     'SparseImageOpaqueMemoryBindInfo' structures
--
-- -   If @imageBindCount@ is not @0@, @pImageBinds@ /must/ be a valid
--     pointer to an array of @imageBindCount@ valid
--     'SparseImageMemoryBindInfo' structures
--
-- -   If @signalSemaphoreCount@ is not @0@, @pSignalSemaphores@ /must/ be
--     a valid pointer to an array of @signalSemaphoreCount@ valid
--     'Graphics.Vulkan.Core10.Handles.Semaphore' handles
--
-- -   Both of the elements of @pSignalSemaphores@, and the elements of
--     @pWaitSemaphores@ that are valid handles of non-ignored parameters
--     /must/ have been created, allocated, or retrieved from the same
--     'Graphics.Vulkan.Core10.Handles.Device'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.Semaphore',
-- 'SparseBufferMemoryBindInfo', 'SparseImageMemoryBindInfo',
-- 'SparseImageOpaqueMemoryBindInfo',
-- 'Graphics.Vulkan.Core10.Enums.StructureType.StructureType',
-- 'queueBindSparse'
data BindSparseInfo (es :: [Type]) = BindSparseInfo
  { -- | @pNext@ is @NULL@ or a pointer to an extension-specific structure.
    next :: Chain es
  , -- | @pWaitSemaphores@ is a pointer to an array of semaphores upon which to
    -- wait on before the sparse binding operations for this batch begin
    -- execution. If semaphores to wait on are provided, they define a
    -- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphores-waiting semaphore wait operation>.
    waitSemaphores :: Vector Semaphore
  , -- | @pBufferBinds@ is a pointer to an array of 'SparseBufferMemoryBindInfo'
    -- structures.
    bufferBinds :: Vector SparseBufferMemoryBindInfo
  , -- | @pImageOpaqueBinds@ is a pointer to an array of
    -- 'SparseImageOpaqueMemoryBindInfo' structures, indicating opaque sparse
    -- image bindings to perform.
    imageOpaqueBinds :: Vector SparseImageOpaqueMemoryBindInfo
  , -- | @pImageBinds@ is a pointer to an array of 'SparseImageMemoryBindInfo'
    -- structures, indicating sparse image bindings to perform.
    imageBinds :: Vector SparseImageMemoryBindInfo
  , -- | @pSignalSemaphores@ is a pointer to an array of semaphores which will be
    -- signaled when the sparse binding operations for this batch have
    -- completed execution. If semaphores to be signaled are provided, they
    -- define a
    -- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#synchronization-semaphores-signaling semaphore signal operation>.
    signalSemaphores :: Vector Semaphore
  }
  deriving (Typeable)
deriving instance Show (Chain es) => Show (BindSparseInfo es)

instance Extensible BindSparseInfo where
  extensibleType = STRUCTURE_TYPE_BIND_SPARSE_INFO
  setNext x next = x{next = next}
  getNext BindSparseInfo{..} = next
  extends :: forall e b proxy. Typeable e => proxy e -> (Extends BindSparseInfo e => b) -> Maybe b
  extends _ f
    | Just Refl <- eqT @e @TimelineSemaphoreSubmitInfo = Just f
    | Just Refl <- eqT @e @DeviceGroupBindSparseInfo = Just f
    | otherwise = Nothing

instance PokeChain es => ToCStruct (BindSparseInfo es) where
  withCStruct x f = allocaBytesAligned 96 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p BindSparseInfo{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_BIND_SPARSE_INFO)
    pNext'' <- fmap castPtr . ContT $ withChain (next)
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext''
    lift $ poke ((p `plusPtr` 16 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (waitSemaphores)) :: Word32))
    pPWaitSemaphores' <- ContT $ allocaBytesAligned @Semaphore ((Data.Vector.length (waitSemaphores)) * 8) 8
    lift $ Data.Vector.imapM_ (\i e -> poke (pPWaitSemaphores' `plusPtr` (8 * (i)) :: Ptr Semaphore) (e)) (waitSemaphores)
    lift $ poke ((p `plusPtr` 24 :: Ptr (Ptr Semaphore))) (pPWaitSemaphores')
    lift $ poke ((p `plusPtr` 32 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (bufferBinds)) :: Word32))
    pPBufferBinds' <- ContT $ allocaBytesAligned @SparseBufferMemoryBindInfo ((Data.Vector.length (bufferBinds)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBufferBinds' `plusPtr` (24 * (i)) :: Ptr SparseBufferMemoryBindInfo) (e) . ($ ())) (bufferBinds)
    lift $ poke ((p `plusPtr` 40 :: Ptr (Ptr SparseBufferMemoryBindInfo))) (pPBufferBinds')
    lift $ poke ((p `plusPtr` 48 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (imageOpaqueBinds)) :: Word32))
    pPImageOpaqueBinds' <- ContT $ allocaBytesAligned @SparseImageOpaqueMemoryBindInfo ((Data.Vector.length (imageOpaqueBinds)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPImageOpaqueBinds' `plusPtr` (24 * (i)) :: Ptr SparseImageOpaqueMemoryBindInfo) (e) . ($ ())) (imageOpaqueBinds)
    lift $ poke ((p `plusPtr` 56 :: Ptr (Ptr SparseImageOpaqueMemoryBindInfo))) (pPImageOpaqueBinds')
    lift $ poke ((p `plusPtr` 64 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (imageBinds)) :: Word32))
    pPImageBinds' <- ContT $ allocaBytesAligned @SparseImageMemoryBindInfo ((Data.Vector.length (imageBinds)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPImageBinds' `plusPtr` (24 * (i)) :: Ptr SparseImageMemoryBindInfo) (e) . ($ ())) (imageBinds)
    lift $ poke ((p `plusPtr` 72 :: Ptr (Ptr SparseImageMemoryBindInfo))) (pPImageBinds')
    lift $ poke ((p `plusPtr` 80 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (signalSemaphores)) :: Word32))
    pPSignalSemaphores' <- ContT $ allocaBytesAligned @Semaphore ((Data.Vector.length (signalSemaphores)) * 8) 8
    lift $ Data.Vector.imapM_ (\i e -> poke (pPSignalSemaphores' `plusPtr` (8 * (i)) :: Ptr Semaphore) (e)) (signalSemaphores)
    lift $ poke ((p `plusPtr` 88 :: Ptr (Ptr Semaphore))) (pPSignalSemaphores')
    lift $ f
  cStructSize = 96
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_BIND_SPARSE_INFO)
    pNext' <- fmap castPtr . ContT $ withZeroChain @es
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext'
    pPWaitSemaphores' <- ContT $ allocaBytesAligned @Semaphore ((Data.Vector.length (mempty)) * 8) 8
    lift $ Data.Vector.imapM_ (\i e -> poke (pPWaitSemaphores' `plusPtr` (8 * (i)) :: Ptr Semaphore) (e)) (mempty)
    lift $ poke ((p `plusPtr` 24 :: Ptr (Ptr Semaphore))) (pPWaitSemaphores')
    pPBufferBinds' <- ContT $ allocaBytesAligned @SparseBufferMemoryBindInfo ((Data.Vector.length (mempty)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBufferBinds' `plusPtr` (24 * (i)) :: Ptr SparseBufferMemoryBindInfo) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 40 :: Ptr (Ptr SparseBufferMemoryBindInfo))) (pPBufferBinds')
    pPImageOpaqueBinds' <- ContT $ allocaBytesAligned @SparseImageOpaqueMemoryBindInfo ((Data.Vector.length (mempty)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPImageOpaqueBinds' `plusPtr` (24 * (i)) :: Ptr SparseImageOpaqueMemoryBindInfo) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 56 :: Ptr (Ptr SparseImageOpaqueMemoryBindInfo))) (pPImageOpaqueBinds')
    pPImageBinds' <- ContT $ allocaBytesAligned @SparseImageMemoryBindInfo ((Data.Vector.length (mempty)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPImageBinds' `plusPtr` (24 * (i)) :: Ptr SparseImageMemoryBindInfo) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 72 :: Ptr (Ptr SparseImageMemoryBindInfo))) (pPImageBinds')
    pPSignalSemaphores' <- ContT $ allocaBytesAligned @Semaphore ((Data.Vector.length (mempty)) * 8) 8
    lift $ Data.Vector.imapM_ (\i e -> poke (pPSignalSemaphores' `plusPtr` (8 * (i)) :: Ptr Semaphore) (e)) (mempty)
    lift $ poke ((p `plusPtr` 88 :: Ptr (Ptr Semaphore))) (pPSignalSemaphores')
    lift $ f

instance PeekChain es => FromCStruct (BindSparseInfo es) where
  peekCStruct p = do
    pNext <- peek @(Ptr ()) ((p `plusPtr` 8 :: Ptr (Ptr ())))
    next <- peekChain (castPtr pNext)
    waitSemaphoreCount <- peek @Word32 ((p `plusPtr` 16 :: Ptr Word32))
    pWaitSemaphores <- peek @(Ptr Semaphore) ((p `plusPtr` 24 :: Ptr (Ptr Semaphore)))
    pWaitSemaphores' <- generateM (fromIntegral waitSemaphoreCount) (\i -> peek @Semaphore ((pWaitSemaphores `advancePtrBytes` (8 * (i)) :: Ptr Semaphore)))
    bufferBindCount <- peek @Word32 ((p `plusPtr` 32 :: Ptr Word32))
    pBufferBinds <- peek @(Ptr SparseBufferMemoryBindInfo) ((p `plusPtr` 40 :: Ptr (Ptr SparseBufferMemoryBindInfo)))
    pBufferBinds' <- generateM (fromIntegral bufferBindCount) (\i -> peekCStruct @SparseBufferMemoryBindInfo ((pBufferBinds `advancePtrBytes` (24 * (i)) :: Ptr SparseBufferMemoryBindInfo)))
    imageOpaqueBindCount <- peek @Word32 ((p `plusPtr` 48 :: Ptr Word32))
    pImageOpaqueBinds <- peek @(Ptr SparseImageOpaqueMemoryBindInfo) ((p `plusPtr` 56 :: Ptr (Ptr SparseImageOpaqueMemoryBindInfo)))
    pImageOpaqueBinds' <- generateM (fromIntegral imageOpaqueBindCount) (\i -> peekCStruct @SparseImageOpaqueMemoryBindInfo ((pImageOpaqueBinds `advancePtrBytes` (24 * (i)) :: Ptr SparseImageOpaqueMemoryBindInfo)))
    imageBindCount <- peek @Word32 ((p `plusPtr` 64 :: Ptr Word32))
    pImageBinds <- peek @(Ptr SparseImageMemoryBindInfo) ((p `plusPtr` 72 :: Ptr (Ptr SparseImageMemoryBindInfo)))
    pImageBinds' <- generateM (fromIntegral imageBindCount) (\i -> peekCStruct @SparseImageMemoryBindInfo ((pImageBinds `advancePtrBytes` (24 * (i)) :: Ptr SparseImageMemoryBindInfo)))
    signalSemaphoreCount <- peek @Word32 ((p `plusPtr` 80 :: Ptr Word32))
    pSignalSemaphores <- peek @(Ptr Semaphore) ((p `plusPtr` 88 :: Ptr (Ptr Semaphore)))
    pSignalSemaphores' <- generateM (fromIntegral signalSemaphoreCount) (\i -> peek @Semaphore ((pSignalSemaphores `advancePtrBytes` (8 * (i)) :: Ptr Semaphore)))
    pure $ BindSparseInfo
             next pWaitSemaphores' pBufferBinds' pImageOpaqueBinds' pImageBinds' pSignalSemaphores'

instance es ~ '[] => Zero (BindSparseInfo es) where
  zero = BindSparseInfo
           ()
           mempty
           mempty
           mempty
           mempty
           mempty

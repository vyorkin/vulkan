{-# language CPP #-}
module Graphics.Vulkan.Core10.DescriptorSet  ( createDescriptorSetLayout
                                             , withDescriptorSetLayout
                                             , destroyDescriptorSetLayout
                                             , createDescriptorPool
                                             , withDescriptorPool
                                             , destroyDescriptorPool
                                             , resetDescriptorPool
                                             , allocateDescriptorSets
                                             , withDescriptorSets
                                             , freeDescriptorSets
                                             , updateDescriptorSets
                                             , DescriptorBufferInfo(..)
                                             , DescriptorImageInfo(..)
                                             , WriteDescriptorSet(..)
                                             , CopyDescriptorSet(..)
                                             , DescriptorSetLayoutBinding(..)
                                             , DescriptorSetLayoutCreateInfo(..)
                                             , DescriptorPoolSize(..)
                                             , DescriptorPoolCreateInfo(..)
                                             , DescriptorSetAllocateInfo(..)
                                             ) where

import Control.Exception.Base (bracket)
import Control.Monad (unless)
import Data.Typeable (eqT)
import Foreign.Marshal.Alloc (allocaBytesAligned)
import Foreign.Marshal.Alloc (callocBytes)
import Foreign.Marshal.Alloc (free)
import Foreign.Marshal.Utils (maybePeek)
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
import Data.Either (Either)
import Data.Type.Equality ((:~:)(Refl))
import Data.Typeable (Typeable)
import Foreign.Storable (Storable)
import Foreign.Storable (Storable(peek))
import Foreign.Storable (Storable(poke))
import qualified Foreign.Storable (Storable(..))
import GHC.IO.Exception (IOErrorType(..))
import GHC.IO.Exception (IOException(..))
import Foreign.Ptr (FunPtr)
import Foreign.Ptr (Ptr)
import Data.Word (Word32)
import Data.Kind (Type)
import Control.Monad.Trans.Cont (ContT(..))
import Data.Vector (Vector)
import Graphics.Vulkan.CStruct.Utils (advancePtrBytes)
import Graphics.Vulkan.NamedType ((:::))
import Graphics.Vulkan.Core10.AllocationCallbacks (AllocationCallbacks)
import Graphics.Vulkan.Core10.Handles (Buffer)
import Graphics.Vulkan.Core10.Handles (BufferView)
import Graphics.Vulkan.CStruct.Extends (Chain)
import Graphics.Vulkan.Core10.Handles (DescriptorPool)
import Graphics.Vulkan.Core10.Handles (DescriptorPool(..))
import Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits (DescriptorPoolCreateFlags)
import {-# SOURCE #-} Graphics.Vulkan.Extensions.VK_EXT_inline_uniform_block (DescriptorPoolInlineUniformBlockCreateInfoEXT)
import Graphics.Vulkan.Core10.Enums.DescriptorPoolResetFlags (DescriptorPoolResetFlags)
import Graphics.Vulkan.Core10.Enums.DescriptorPoolResetFlags (DescriptorPoolResetFlags(..))
import Graphics.Vulkan.Core10.Handles (DescriptorSet)
import Graphics.Vulkan.Core10.Handles (DescriptorSet(..))
import Graphics.Vulkan.Core10.Handles (DescriptorSetLayout)
import Graphics.Vulkan.Core10.Handles (DescriptorSetLayout(..))
import {-# SOURCE #-} Graphics.Vulkan.Core12.Promoted_From_VK_EXT_descriptor_indexing (DescriptorSetLayoutBindingFlagsCreateInfo)
import Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits (DescriptorSetLayoutCreateFlags)
import {-# SOURCE #-} Graphics.Vulkan.Core12.Promoted_From_VK_EXT_descriptor_indexing (DescriptorSetVariableDescriptorCountAllocateInfo)
import Graphics.Vulkan.Core10.Enums.DescriptorType (DescriptorType)
import Graphics.Vulkan.Core10.Handles (Device)
import Graphics.Vulkan.Core10.Handles (Device(..))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkAllocateDescriptorSets))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkCreateDescriptorPool))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkCreateDescriptorSetLayout))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkDestroyDescriptorPool))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkDestroyDescriptorSetLayout))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkFreeDescriptorSets))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkResetDescriptorPool))
import Graphics.Vulkan.Dynamic (DeviceCmds(pVkUpdateDescriptorSets))
import Graphics.Vulkan.Core10.BaseType (DeviceSize)
import Graphics.Vulkan.Core10.Handles (Device_T)
import Graphics.Vulkan.CStruct.Extends (Extends)
import Graphics.Vulkan.CStruct.Extends (Extensible(..))
import Graphics.Vulkan.CStruct (FromCStruct)
import Graphics.Vulkan.CStruct (FromCStruct(..))
import Graphics.Vulkan.Core10.Enums.ImageLayout (ImageLayout)
import Graphics.Vulkan.Core10.Handles (ImageView)
import Graphics.Vulkan.CStruct.Extends (PeekChain)
import Graphics.Vulkan.CStruct.Extends (PeekChain(..))
import Graphics.Vulkan.CStruct.Extends (PokeChain)
import Graphics.Vulkan.CStruct.Extends (PokeChain(..))
import Graphics.Vulkan.Core10.Enums.Result (Result)
import Graphics.Vulkan.Core10.Enums.Result (Result(..))
import Graphics.Vulkan.Core10.Handles (Sampler)
import Graphics.Vulkan.Core10.Enums.ShaderStageFlagBits (ShaderStageFlags)
import Graphics.Vulkan.Core10.Enums.StructureType (StructureType)
import Graphics.Vulkan.CStruct (ToCStruct)
import Graphics.Vulkan.CStruct (ToCStruct(..))
import Graphics.Vulkan.Exception (VulkanException(..))
import {-# SOURCE #-} Graphics.Vulkan.Extensions.VK_NV_ray_tracing (WriteDescriptorSetAccelerationStructureNV)
import {-# SOURCE #-} Graphics.Vulkan.Extensions.VK_EXT_inline_uniform_block (WriteDescriptorSetInlineUniformBlockEXT)
import Graphics.Vulkan.Zero (Zero(..))
import Graphics.Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_COPY_DESCRIPTOR_SET))
import Graphics.Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO))
import Graphics.Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO))
import Graphics.Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO))
import Graphics.Vulkan.Core10.Enums.StructureType (StructureType(STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET))
import Graphics.Vulkan.Core10.Enums.Result (Result(SUCCESS))
foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkCreateDescriptorSetLayout
  :: FunPtr (Ptr Device_T -> Ptr (DescriptorSetLayoutCreateInfo a) -> Ptr AllocationCallbacks -> Ptr DescriptorSetLayout -> IO Result) -> Ptr Device_T -> Ptr (DescriptorSetLayoutCreateInfo a) -> Ptr AllocationCallbacks -> Ptr DescriptorSetLayout -> IO Result

-- | vkCreateDescriptorSetLayout - Create a new descriptor set layout
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' is the logical device that
--     creates the descriptor set layout.
--
-- -   @pCreateInfo@ is a pointer to a 'DescriptorSetLayoutCreateInfo'
--     structure specifying the state of the descriptor set layout object.
--
-- -   @pAllocator@ controls host memory allocation as described in the
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#memory-allocation Memory Allocation>
--     chapter.
--
-- -   @pSetLayout@ is a pointer to a
--     'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' handle in which
--     the resulting descriptor set layout object is returned.
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Device' handle
--
-- -   @pCreateInfo@ /must/ be a valid pointer to a valid
--     'DescriptorSetLayoutCreateInfo' structure
--
-- -   If @pAllocator@ is not @NULL@, @pAllocator@ /must/ be a valid
--     pointer to a valid
--     'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks'
--     structure
--
-- -   @pSetLayout@ /must/ be a valid pointer to a
--     'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' handle
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
-- = See Also
--
-- 'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks',
-- 'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout',
-- 'DescriptorSetLayoutCreateInfo', 'Graphics.Vulkan.Core10.Handles.Device'
createDescriptorSetLayout :: PokeChain a => Device -> DescriptorSetLayoutCreateInfo a -> ("allocator" ::: Maybe AllocationCallbacks) -> IO (DescriptorSetLayout)
createDescriptorSetLayout device createInfo allocator = evalContT $ do
  let vkCreateDescriptorSetLayout' = mkVkCreateDescriptorSetLayout (pVkCreateDescriptorSetLayout (deviceCmds (device :: Device)))
  pCreateInfo <- ContT $ withCStruct (createInfo)
  pAllocator <- case (allocator) of
    Nothing -> pure nullPtr
    Just j -> ContT $ withCStruct (j)
  pPSetLayout <- ContT $ bracket (callocBytes @DescriptorSetLayout 8) free
  r <- lift $ vkCreateDescriptorSetLayout' (deviceHandle (device)) pCreateInfo pAllocator (pPSetLayout)
  lift $ when (r < SUCCESS) (throwIO (VulkanException r))
  pSetLayout <- lift $ peek @DescriptorSetLayout pPSetLayout
  pure $ (pSetLayout)

-- | A safe wrapper for 'createDescriptorSetLayout' and
-- 'destroyDescriptorSetLayout' using 'bracket'
--
-- The allocated value must not be returned from the provided computation
withDescriptorSetLayout :: PokeChain a => Device -> DescriptorSetLayoutCreateInfo a -> Maybe AllocationCallbacks -> (DescriptorSetLayout -> IO r) -> IO r
withDescriptorSetLayout device descriptorSetLayoutCreateInfo allocationCallbacks =
  bracket
    (createDescriptorSetLayout device descriptorSetLayoutCreateInfo allocationCallbacks)
    (\o -> destroyDescriptorSetLayout device o allocationCallbacks)


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkDestroyDescriptorSetLayout
  :: FunPtr (Ptr Device_T -> DescriptorSetLayout -> Ptr AllocationCallbacks -> IO ()) -> Ptr Device_T -> DescriptorSetLayout -> Ptr AllocationCallbacks -> IO ()

-- | vkDestroyDescriptorSetLayout - Destroy a descriptor set layout object
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' is the logical device that
--     destroys the descriptor set layout.
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' is the
--     descriptor set layout to destroy.
--
-- -   @pAllocator@ controls host memory allocation as described in the
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#memory-allocation Memory Allocation>
--     chapter.
--
-- == Valid Usage
--
-- -   If 'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks'
--     were provided when
--     'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' was created, a
--     compatible set of callbacks /must/ be provided here
--
-- -   If no
--     'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks'
--     were provided when
--     'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' was created,
--     @pAllocator@ /must/ be @NULL@
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Device' handle
--
-- -   If 'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' is not
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE',
--     'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' /must/ be a
--     valid 'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' handle
--
-- -   If @pAllocator@ is not @NULL@, @pAllocator@ /must/ be a valid
--     pointer to a valid
--     'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks'
--     structure
--
-- -   If 'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' is a valid
--     handle, it /must/ have been created, allocated, or retrieved from
--     'Graphics.Vulkan.Core10.Handles.Device'
--
-- == Host Synchronization
--
-- -   Host access to 'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout'
--     /must/ be externally synchronized
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks',
-- 'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout',
-- 'Graphics.Vulkan.Core10.Handles.Device'
destroyDescriptorSetLayout :: Device -> DescriptorSetLayout -> ("allocator" ::: Maybe AllocationCallbacks) -> IO ()
destroyDescriptorSetLayout device descriptorSetLayout allocator = evalContT $ do
  let vkDestroyDescriptorSetLayout' = mkVkDestroyDescriptorSetLayout (pVkDestroyDescriptorSetLayout (deviceCmds (device :: Device)))
  pAllocator <- case (allocator) of
    Nothing -> pure nullPtr
    Just j -> ContT $ withCStruct (j)
  lift $ vkDestroyDescriptorSetLayout' (deviceHandle (device)) (descriptorSetLayout) pAllocator
  pure $ ()


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkCreateDescriptorPool
  :: FunPtr (Ptr Device_T -> Ptr (DescriptorPoolCreateInfo a) -> Ptr AllocationCallbacks -> Ptr DescriptorPool -> IO Result) -> Ptr Device_T -> Ptr (DescriptorPoolCreateInfo a) -> Ptr AllocationCallbacks -> Ptr DescriptorPool -> IO Result

-- | vkCreateDescriptorPool - Creates a descriptor pool object
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' is the logical device that
--     creates the descriptor pool.
--
-- -   @pCreateInfo@ is a pointer to a 'DescriptorPoolCreateInfo' structure
--     specifying the state of the descriptor pool object.
--
-- -   @pAllocator@ controls host memory allocation as described in the
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#memory-allocation Memory Allocation>
--     chapter.
--
-- -   @pDescriptorPool@ is a pointer to a
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool' handle in which the
--     resulting descriptor pool object is returned.
--
-- = Description
--
-- @pAllocator@ controls host memory allocation as described in the
-- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#memory-allocation Memory Allocation>
-- chapter.
--
-- The created descriptor pool is returned in @pDescriptorPool@.
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Device' handle
--
-- -   @pCreateInfo@ /must/ be a valid pointer to a valid
--     'DescriptorPoolCreateInfo' structure
--
-- -   If @pAllocator@ is not @NULL@, @pAllocator@ /must/ be a valid
--     pointer to a valid
--     'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks'
--     structure
--
-- -   @pDescriptorPool@ /must/ be a valid pointer to a
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool' handle
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
--     -   'Graphics.Vulkan.Extensions.VK_EXT_descriptor_indexing.ERROR_FRAGMENTATION_EXT'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks',
-- 'Graphics.Vulkan.Core10.Handles.DescriptorPool',
-- 'DescriptorPoolCreateInfo', 'Graphics.Vulkan.Core10.Handles.Device'
createDescriptorPool :: PokeChain a => Device -> DescriptorPoolCreateInfo a -> ("allocator" ::: Maybe AllocationCallbacks) -> IO (DescriptorPool)
createDescriptorPool device createInfo allocator = evalContT $ do
  let vkCreateDescriptorPool' = mkVkCreateDescriptorPool (pVkCreateDescriptorPool (deviceCmds (device :: Device)))
  pCreateInfo <- ContT $ withCStruct (createInfo)
  pAllocator <- case (allocator) of
    Nothing -> pure nullPtr
    Just j -> ContT $ withCStruct (j)
  pPDescriptorPool <- ContT $ bracket (callocBytes @DescriptorPool 8) free
  r <- lift $ vkCreateDescriptorPool' (deviceHandle (device)) pCreateInfo pAllocator (pPDescriptorPool)
  lift $ when (r < SUCCESS) (throwIO (VulkanException r))
  pDescriptorPool <- lift $ peek @DescriptorPool pPDescriptorPool
  pure $ (pDescriptorPool)

-- | A safe wrapper for 'createDescriptorPool' and 'destroyDescriptorPool'
-- using 'bracket'
--
-- The allocated value must not be returned from the provided computation
withDescriptorPool :: PokeChain a => Device -> DescriptorPoolCreateInfo a -> Maybe AllocationCallbacks -> (DescriptorPool -> IO r) -> IO r
withDescriptorPool device descriptorPoolCreateInfo allocationCallbacks =
  bracket
    (createDescriptorPool device descriptorPoolCreateInfo allocationCallbacks)
    (\o -> destroyDescriptorPool device o allocationCallbacks)


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkDestroyDescriptorPool
  :: FunPtr (Ptr Device_T -> DescriptorPool -> Ptr AllocationCallbacks -> IO ()) -> Ptr Device_T -> DescriptorPool -> Ptr AllocationCallbacks -> IO ()

-- | vkDestroyDescriptorPool - Destroy a descriptor pool object
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' is the logical device that
--     destroys the descriptor pool.
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorPool' is the descriptor
--     pool to destroy.
--
-- -   @pAllocator@ controls host memory allocation as described in the
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#memory-allocation Memory Allocation>
--     chapter.
--
-- = Description
--
-- When a pool is destroyed, all descriptor sets allocated from the pool
-- are implicitly freed and become invalid. Descriptor sets allocated from
-- a given pool do not need to be freed before destroying that descriptor
-- pool.
--
-- == Valid Usage
--
-- -   All submitted commands that refer to
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool' (via any allocated
--     descriptor sets) /must/ have completed execution
--
-- -   If 'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks'
--     were provided when 'Graphics.Vulkan.Core10.Handles.DescriptorPool'
--     was created, a compatible set of callbacks /must/ be provided here
--
-- -   If no
--     'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks'
--     were provided when 'Graphics.Vulkan.Core10.Handles.DescriptorPool'
--     was created, @pAllocator@ /must/ be @NULL@
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Device' handle
--
-- -   If 'Graphics.Vulkan.Core10.Handles.DescriptorPool' is not
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE',
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool' handle
--
-- -   If @pAllocator@ is not @NULL@, @pAllocator@ /must/ be a valid
--     pointer to a valid
--     'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks'
--     structure
--
-- -   If 'Graphics.Vulkan.Core10.Handles.DescriptorPool' is a valid
--     handle, it /must/ have been created, allocated, or retrieved from
--     'Graphics.Vulkan.Core10.Handles.Device'
--
-- == Host Synchronization
--
-- -   Host access to 'Graphics.Vulkan.Core10.Handles.DescriptorPool'
--     /must/ be externally synchronized
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.AllocationCallbacks.AllocationCallbacks',
-- 'Graphics.Vulkan.Core10.Handles.DescriptorPool',
-- 'Graphics.Vulkan.Core10.Handles.Device'
destroyDescriptorPool :: Device -> DescriptorPool -> ("allocator" ::: Maybe AllocationCallbacks) -> IO ()
destroyDescriptorPool device descriptorPool allocator = evalContT $ do
  let vkDestroyDescriptorPool' = mkVkDestroyDescriptorPool (pVkDestroyDescriptorPool (deviceCmds (device :: Device)))
  pAllocator <- case (allocator) of
    Nothing -> pure nullPtr
    Just j -> ContT $ withCStruct (j)
  lift $ vkDestroyDescriptorPool' (deviceHandle (device)) (descriptorPool) pAllocator
  pure $ ()


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkResetDescriptorPool
  :: FunPtr (Ptr Device_T -> DescriptorPool -> DescriptorPoolResetFlags -> IO Result) -> Ptr Device_T -> DescriptorPool -> DescriptorPoolResetFlags -> IO Result

-- | vkResetDescriptorPool - Resets a descriptor pool object
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' is the logical device that
--     owns the descriptor pool.
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorPool' is the descriptor
--     pool to be reset.
--
-- -   'Graphics.Vulkan.Core10.BaseType.Flags' is reserved for future use.
--
-- = Description
--
-- Resetting a descriptor pool recycles all of the resources from all of
-- the descriptor sets allocated from the descriptor pool back to the
-- descriptor pool, and the descriptor sets are implicitly freed.
--
-- == Valid Usage
--
-- -   All uses of 'Graphics.Vulkan.Core10.Handles.DescriptorPool' (via any
--     allocated descriptor sets) /must/ have completed execution
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Device' handle
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorPool' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool' handle
--
-- -   'Graphics.Vulkan.Core10.BaseType.Flags' /must/ be @0@
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorPool' /must/ have been
--     created, allocated, or retrieved from
--     'Graphics.Vulkan.Core10.Handles.Device'
--
-- == Host Synchronization
--
-- -   Host access to 'Graphics.Vulkan.Core10.Handles.DescriptorPool'
--     /must/ be externally synchronized
--
-- -   Host access to any 'Graphics.Vulkan.Core10.Handles.DescriptorSet'
--     objects allocated from
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool' /must/ be externally
--     synchronized
--
-- == Return Codes
--
-- [<https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#fundamentals-successcodes Success>]
--
--     -   'Graphics.Vulkan.Core10.Enums.Result.SUCCESS'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.DescriptorPool',
-- 'Graphics.Vulkan.Core10.Enums.DescriptorPoolResetFlags.DescriptorPoolResetFlags',
-- 'Graphics.Vulkan.Core10.Handles.Device'
resetDescriptorPool :: Device -> DescriptorPool -> DescriptorPoolResetFlags -> IO ()
resetDescriptorPool device descriptorPool flags = do
  let vkResetDescriptorPool' = mkVkResetDescriptorPool (pVkResetDescriptorPool (deviceCmds (device :: Device)))
  _ <- vkResetDescriptorPool' (deviceHandle (device)) (descriptorPool) (flags)
  pure $ ()


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkAllocateDescriptorSets
  :: FunPtr (Ptr Device_T -> Ptr (DescriptorSetAllocateInfo a) -> Ptr DescriptorSet -> IO Result) -> Ptr Device_T -> Ptr (DescriptorSetAllocateInfo a) -> Ptr DescriptorSet -> IO Result

-- | vkAllocateDescriptorSets - Allocate one or more descriptor sets
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' is the logical device that
--     owns the descriptor pool.
--
-- -   @pAllocateInfo@ is a pointer to a 'DescriptorSetAllocateInfo'
--     structure describing parameters of the allocation.
--
-- -   @pDescriptorSets@ is a pointer to an array of
--     'Graphics.Vulkan.Core10.Handles.DescriptorSet' handles in which the
--     resulting descriptor set objects are returned.
--
-- = Description
--
-- The allocated descriptor sets are returned in @pDescriptorSets@.
--
-- When a descriptor set is allocated, the initial state is largely
-- uninitialized and all descriptors are undefined. Descriptors also become
-- undefined if the underlying resource is destroyed. Descriptor sets
-- containing undefined descriptors /can/ still be bound and used, subject
-- to the following conditions:
--
-- -   For descriptor set bindings created with the
--     'Graphics.Vulkan.Core12.Enums.DescriptorBindingFlagBits.DESCRIPTOR_BINDING_PARTIALLY_BOUND_BIT'
--     bit set, all descriptors in that binding that are dynamically used
--     /must/ have been populated before the descriptor set is
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#descriptorsets-binding consumed>.
--
-- -   For descriptor set bindings created without the
--     'Graphics.Vulkan.Core12.Enums.DescriptorBindingFlagBits.DESCRIPTOR_BINDING_PARTIALLY_BOUND_BIT'
--     bit set, all descriptors in that binding that are statically used
--     /must/ have been populated before the descriptor set is
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#descriptorsets-binding consumed>.
--
-- -   Descriptor bindings with descriptor type of
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
--     /can/ be undefined when the descriptor set is
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#descriptorsets-binding consumed>;
--     though values in that block will be undefined.
--
-- -   Entries that are not used by a pipeline /can/ have undefined
--     descriptors.
--
-- If a call to 'allocateDescriptorSets' would cause the total number of
-- descriptor sets allocated from the pool to exceed the value of
-- 'DescriptorPoolCreateInfo'::@maxSets@ used to create
-- @pAllocateInfo->descriptorPool@, then the allocation /may/ fail due to
-- lack of space in the descriptor pool. Similarly, the allocation /may/
-- fail due to lack of space if the call to 'allocateDescriptorSets' would
-- cause the number of any given descriptor type to exceed the sum of all
-- the @descriptorCount@ members of each element of
-- 'DescriptorPoolCreateInfo'::@pPoolSizes@ with a @member@ equal to that
-- type.
--
-- Additionally, the allocation /may/ also fail if a call to
-- 'allocateDescriptorSets' would cause the total number of inline uniform
-- block bindings allocated from the pool to exceed the value of
-- 'Graphics.Vulkan.Extensions.VK_EXT_inline_uniform_block.DescriptorPoolInlineUniformBlockCreateInfoEXT'::@maxInlineUniformBlockBindings@
-- used to create the descriptor pool.
--
-- If the allocation fails due to no more space in the descriptor pool, and
-- not because of system or device memory exhaustion, then
-- 'Graphics.Vulkan.Core10.Enums.Result.ERROR_OUT_OF_POOL_MEMORY' /must/ be
-- returned.
--
-- 'allocateDescriptorSets' /can/ be used to create multiple descriptor
-- sets. If the creation of any of those descriptor sets fails, then the
-- implementation /must/ destroy all successfully created descriptor set
-- objects from this command, set all entries of the @pDescriptorSets@
-- array to 'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE' and return
-- the error.
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Device' handle
--
-- -   @pAllocateInfo@ /must/ be a valid pointer to a valid
--     'DescriptorSetAllocateInfo' structure
--
-- -   @pDescriptorSets@ /must/ be a valid pointer to an array of
--     @pAllocateInfo@::descriptorSetCount
--     'Graphics.Vulkan.Core10.Handles.DescriptorSet' handles
--
-- -   The value referenced by @pAllocateInfo@::@descriptorSetCount@ /must/
--     be greater than @0@
--
-- == Host Synchronization
--
-- -   Host access to @pAllocateInfo@::descriptorPool /must/ be externally
--     synchronized
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
--     -   'Graphics.Vulkan.Core10.Enums.Result.ERROR_FRAGMENTED_POOL'
--
--     -   'Graphics.Vulkan.Core10.Enums.Result.ERROR_OUT_OF_POOL_MEMORY'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.DescriptorSet',
-- 'DescriptorSetAllocateInfo', 'Graphics.Vulkan.Core10.Handles.Device'
allocateDescriptorSets :: PokeChain a => Device -> DescriptorSetAllocateInfo a -> IO (("descriptorSets" ::: Vector DescriptorSet))
allocateDescriptorSets device allocateInfo = evalContT $ do
  let vkAllocateDescriptorSets' = mkVkAllocateDescriptorSets (pVkAllocateDescriptorSets (deviceCmds (device :: Device)))
  pAllocateInfo <- ContT $ withCStruct (allocateInfo)
  pPDescriptorSets <- ContT $ bracket (callocBytes @DescriptorSet ((fromIntegral . Data.Vector.length . setLayouts $ (allocateInfo)) * 8)) free
  r <- lift $ vkAllocateDescriptorSets' (deviceHandle (device)) pAllocateInfo (pPDescriptorSets)
  lift $ when (r < SUCCESS) (throwIO (VulkanException r))
  pDescriptorSets <- lift $ generateM (fromIntegral . Data.Vector.length . setLayouts $ (allocateInfo)) (\i -> peek @DescriptorSet ((pPDescriptorSets `advancePtrBytes` (8 * (i)) :: Ptr DescriptorSet)))
  pure $ (pDescriptorSets)

-- | A safe wrapper for 'allocateDescriptorSets' and 'freeDescriptorSets'
-- using 'bracket'
--
-- The allocated value must not be returned from the provided computation
withDescriptorSets :: PokeChain a => Device -> DescriptorSetAllocateInfo a -> (Vector DescriptorSet -> IO r) -> IO r
withDescriptorSets device descriptorSetAllocateInfo =
  bracket
    (allocateDescriptorSets device descriptorSetAllocateInfo)
    (\o -> freeDescriptorSets device (descriptorPool (descriptorSetAllocateInfo :: DescriptorSetAllocateInfo _)) o)


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkFreeDescriptorSets
  :: FunPtr (Ptr Device_T -> DescriptorPool -> Word32 -> Ptr DescriptorSet -> IO Result) -> Ptr Device_T -> DescriptorPool -> Word32 -> Ptr DescriptorSet -> IO Result

-- | vkFreeDescriptorSets - Free one or more descriptor sets
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' is the logical device that
--     owns the descriptor pool.
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorPool' is the descriptor
--     pool from which the descriptor sets were allocated.
--
-- -   @descriptorSetCount@ is the number of elements in the
--     @pDescriptorSets@ array.
--
-- -   @pDescriptorSets@ is a pointer to an array of handles to
--     'Graphics.Vulkan.Core10.Handles.DescriptorSet' objects.
--
-- = Description
--
-- After calling 'freeDescriptorSets', all descriptor sets in
-- @pDescriptorSets@ are invalid.
--
-- == Valid Usage
--
-- -   All submitted commands that refer to any element of
--     @pDescriptorSets@ /must/ have completed execution
--
-- -   @pDescriptorSets@ /must/ be a valid pointer to an array of
--     @descriptorSetCount@ 'Graphics.Vulkan.Core10.Handles.DescriptorSet'
--     handles, each element of which /must/ either be a valid handle or
--     'Graphics.Vulkan.Core10.APIConstants.NULL_HANDLE'
--
-- -   Each valid handle in @pDescriptorSets@ /must/ have been allocated
--     from 'Graphics.Vulkan.Core10.Handles.DescriptorPool'
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorPool' /must/ have been
--     created with the
--     'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DESCRIPTOR_POOL_CREATE_FREE_DESCRIPTOR_SET_BIT'
--     flag
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Device' handle
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorPool' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool' handle
--
-- -   @descriptorSetCount@ /must/ be greater than @0@
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorPool' /must/ have been
--     created, allocated, or retrieved from
--     'Graphics.Vulkan.Core10.Handles.Device'
--
-- -   Each element of @pDescriptorSets@ that is a valid handle /must/ have
--     been created, allocated, or retrieved from
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool'
--
-- == Host Synchronization
--
-- -   Host access to 'Graphics.Vulkan.Core10.Handles.DescriptorPool'
--     /must/ be externally synchronized
--
-- -   Host access to each member of @pDescriptorSets@ /must/ be externally
--     synchronized
--
-- == Return Codes
--
-- [<https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#fundamentals-successcodes Success>]
--
--     -   'Graphics.Vulkan.Core10.Enums.Result.SUCCESS'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.DescriptorPool',
-- 'Graphics.Vulkan.Core10.Handles.DescriptorSet',
-- 'Graphics.Vulkan.Core10.Handles.Device'
freeDescriptorSets :: Device -> DescriptorPool -> ("descriptorSets" ::: Vector DescriptorSet) -> IO ()
freeDescriptorSets device descriptorPool descriptorSets = evalContT $ do
  let vkFreeDescriptorSets' = mkVkFreeDescriptorSets (pVkFreeDescriptorSets (deviceCmds (device :: Device)))
  pPDescriptorSets <- ContT $ allocaBytesAligned @DescriptorSet ((Data.Vector.length (descriptorSets)) * 8) 8
  lift $ Data.Vector.imapM_ (\i e -> poke (pPDescriptorSets `plusPtr` (8 * (i)) :: Ptr DescriptorSet) (e)) (descriptorSets)
  _ <- lift $ vkFreeDescriptorSets' (deviceHandle (device)) (descriptorPool) ((fromIntegral (Data.Vector.length $ (descriptorSets)) :: Word32)) (pPDescriptorSets)
  pure $ ()


foreign import ccall
#if !defined(SAFE_FOREIGN_CALLS)
  unsafe
#endif
  "dynamic" mkVkUpdateDescriptorSets
  :: FunPtr (Ptr Device_T -> Word32 -> Ptr (WriteDescriptorSet a) -> Word32 -> Ptr CopyDescriptorSet -> IO ()) -> Ptr Device_T -> Word32 -> Ptr (WriteDescriptorSet a) -> Word32 -> Ptr CopyDescriptorSet -> IO ()

-- | vkUpdateDescriptorSets - Update the contents of a descriptor set object
--
-- = Parameters
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' is the logical device that
--     updates the descriptor sets.
--
-- -   @descriptorWriteCount@ is the number of elements in the
--     @pDescriptorWrites@ array.
--
-- -   @pDescriptorWrites@ is a pointer to an array of 'WriteDescriptorSet'
--     structures describing the descriptor sets to write to.
--
-- -   @descriptorCopyCount@ is the number of elements in the
--     @pDescriptorCopies@ array.
--
-- -   @pDescriptorCopies@ is a pointer to an array of 'CopyDescriptorSet'
--     structures describing the descriptor sets to copy between.
--
-- = Description
--
-- The operations described by @pDescriptorWrites@ are performed first,
-- followed by the operations described by @pDescriptorCopies@. Within each
-- array, the operations are performed in the order they appear in the
-- array.
--
-- Each element in the @pDescriptorWrites@ array describes an operation
-- updating the descriptor set using descriptors for resources specified in
-- the structure.
--
-- Each element in the @pDescriptorCopies@ array is a 'CopyDescriptorSet'
-- structure describing an operation copying descriptors between sets.
--
-- If the @dstSet@ member of any element of @pDescriptorWrites@ or
-- @pDescriptorCopies@ is bound, accessed, or modified by any command that
-- was recorded to a command buffer which is currently in the
-- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#commandbuffers-lifecycle recording or executable state>,
-- and any of the descriptor bindings that are updated were not created
-- with the
-- 'Graphics.Vulkan.Core12.Enums.DescriptorBindingFlagBits.DESCRIPTOR_BINDING_UPDATE_AFTER_BIND_BIT'
-- or
-- 'Graphics.Vulkan.Core12.Enums.DescriptorBindingFlagBits.DESCRIPTOR_BINDING_UPDATE_UNUSED_WHILE_PENDING_BIT'
-- bits set, that command buffer becomes
-- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#commandbuffers-lifecycle invalid>.
--
-- == Valid Usage
--
-- -   Descriptor bindings updated by this command which were created
--     without the
--     'Graphics.Vulkan.Core12.Enums.DescriptorBindingFlagBits.DESCRIPTOR_BINDING_UPDATE_AFTER_BIND_BIT'
--     or
--     'Graphics.Vulkan.Core12.Enums.DescriptorBindingFlagBits.DESCRIPTOR_BINDING_UPDATE_UNUSED_WHILE_PENDING_BIT'
--     bits set /must/ not be used by any command that was recorded to a
--     command buffer which is in the
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#commandbuffers-lifecycle pending state>.
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Device' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Device' handle
--
-- -   If @descriptorWriteCount@ is not @0@, @pDescriptorWrites@ /must/ be
--     a valid pointer to an array of @descriptorWriteCount@ valid
--     'WriteDescriptorSet' structures
--
-- -   If @descriptorCopyCount@ is not @0@, @pDescriptorCopies@ /must/ be a
--     valid pointer to an array of @descriptorCopyCount@ valid
--     'CopyDescriptorSet' structures
--
-- == Host Synchronization
--
-- -   Host access to @pDescriptorWrites@[].dstSet /must/ be externally
--     synchronized
--
-- -   Host access to @pDescriptorCopies@[].dstSet /must/ be externally
--     synchronized
--
-- = See Also
--
-- 'CopyDescriptorSet', 'Graphics.Vulkan.Core10.Handles.Device',
-- 'WriteDescriptorSet'
updateDescriptorSets :: PokeChain a => Device -> ("descriptorWrites" ::: Vector (WriteDescriptorSet a)) -> ("descriptorCopies" ::: Vector CopyDescriptorSet) -> IO ()
updateDescriptorSets device descriptorWrites descriptorCopies = evalContT $ do
  let vkUpdateDescriptorSets' = mkVkUpdateDescriptorSets (pVkUpdateDescriptorSets (deviceCmds (device :: Device)))
  pPDescriptorWrites <- ContT $ allocaBytesAligned @(WriteDescriptorSet _) ((Data.Vector.length (descriptorWrites)) * 64) 8
  Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPDescriptorWrites `plusPtr` (64 * (i)) :: Ptr (WriteDescriptorSet _)) (e) . ($ ())) (descriptorWrites)
  pPDescriptorCopies <- ContT $ allocaBytesAligned @CopyDescriptorSet ((Data.Vector.length (descriptorCopies)) * 56) 8
  Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPDescriptorCopies `plusPtr` (56 * (i)) :: Ptr CopyDescriptorSet) (e) . ($ ())) (descriptorCopies)
  lift $ vkUpdateDescriptorSets' (deviceHandle (device)) ((fromIntegral (Data.Vector.length $ (descriptorWrites)) :: Word32)) (pPDescriptorWrites) ((fromIntegral (Data.Vector.length $ (descriptorCopies)) :: Word32)) (pPDescriptorCopies)
  pure $ ()


-- | VkDescriptorBufferInfo - Structure specifying descriptor buffer info
--
-- = Description
--
-- Note
--
-- When setting @range@ to
-- 'Graphics.Vulkan.Core10.APIConstants.WHOLE_SIZE', the effective range
-- /must/ not be larger than the maximum range for the descriptor type
-- (<https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#limits-maxUniformBufferRange maxUniformBufferRange>
-- or
-- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#limits-maxStorageBufferRange maxStorageBufferRange>).
-- This means that 'Graphics.Vulkan.Core10.APIConstants.WHOLE_SIZE' is not
-- typically useful in the common case where uniform buffer descriptors are
-- suballocated from a buffer that is much larger than
-- @maxUniformBufferRange@.
--
-- For
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC'
-- and
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC'
-- descriptor types, @offset@ is the base offset from which the dynamic
-- offset is applied and @range@ is the static size used for all dynamic
-- offsets.
--
-- == Valid Usage
--
-- -   @offset@ /must/ be less than the size of
--     'Graphics.Vulkan.Core10.Handles.Buffer'
--
-- -   If @range@ is not equal to
--     'Graphics.Vulkan.Core10.APIConstants.WHOLE_SIZE', @range@ /must/ be
--     greater than @0@
--
-- -   If @range@ is not equal to
--     'Graphics.Vulkan.Core10.APIConstants.WHOLE_SIZE', @range@ /must/ be
--     less than or equal to the size of
--     'Graphics.Vulkan.Core10.Handles.Buffer' minus @offset@
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Handles.Buffer' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Buffer' handle
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.Buffer',
-- 'Graphics.Vulkan.Core10.BaseType.DeviceSize', 'WriteDescriptorSet'
data DescriptorBufferInfo = DescriptorBufferInfo
  { -- | 'Graphics.Vulkan.Core10.Handles.Buffer' is the buffer resource.
    buffer :: Buffer
  , -- | @offset@ is the offset in bytes from the start of
    -- 'Graphics.Vulkan.Core10.Handles.Buffer'. Access to buffer memory via
    -- this descriptor uses addressing that is relative to this starting
    -- offset.
    offset :: DeviceSize
  , -- | @range@ is the size in bytes that is used for this descriptor update, or
    -- 'Graphics.Vulkan.Core10.APIConstants.WHOLE_SIZE' to use the range from
    -- @offset@ to the end of the buffer.
    range :: DeviceSize
  }
  deriving (Typeable)
deriving instance Show DescriptorBufferInfo

instance ToCStruct DescriptorBufferInfo where
  withCStruct x f = allocaBytesAligned 24 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p DescriptorBufferInfo{..} f = do
    poke ((p `plusPtr` 0 :: Ptr Buffer)) (buffer)
    poke ((p `plusPtr` 8 :: Ptr DeviceSize)) (offset)
    poke ((p `plusPtr` 16 :: Ptr DeviceSize)) (range)
    f
  cStructSize = 24
  cStructAlignment = 8
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr Buffer)) (zero)
    poke ((p `plusPtr` 8 :: Ptr DeviceSize)) (zero)
    poke ((p `plusPtr` 16 :: Ptr DeviceSize)) (zero)
    f

instance FromCStruct DescriptorBufferInfo where
  peekCStruct p = do
    buffer <- peek @Buffer ((p `plusPtr` 0 :: Ptr Buffer))
    offset <- peek @DeviceSize ((p `plusPtr` 8 :: Ptr DeviceSize))
    range <- peek @DeviceSize ((p `plusPtr` 16 :: Ptr DeviceSize))
    pure $ DescriptorBufferInfo
             buffer offset range

instance Storable DescriptorBufferInfo where
  sizeOf ~_ = 24
  alignment ~_ = 8
  peek = peekCStruct
  poke ptr poked = pokeCStruct ptr poked (pure ())

instance Zero DescriptorBufferInfo where
  zero = DescriptorBufferInfo
           zero
           zero
           zero


-- | VkDescriptorImageInfo - Structure specifying descriptor image info
--
-- = Description
--
-- Members of 'DescriptorImageInfo' that are not used in an update (as
-- described above) are ignored.
--
-- == Valid Usage
--
-- -   'Graphics.Vulkan.Core10.Handles.ImageView' /must/ not be 2D or 2D
--     array image view created from a 3D image
--
-- -   If 'Graphics.Vulkan.Core10.Handles.ImageView' is created from a
--     depth\/stencil image, the @aspectMask@ used to create the
--     'Graphics.Vulkan.Core10.Handles.ImageView' /must/ include either
--     'Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits.IMAGE_ASPECT_DEPTH_BIT'
--     or
--     'Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits.IMAGE_ASPECT_STENCIL_BIT'
--     but not both.
--
-- -   'Graphics.Vulkan.Core10.Enums.ImageLayout.ImageLayout' /must/ match
--     the actual 'Graphics.Vulkan.Core10.Enums.ImageLayout.ImageLayout' of
--     each subresource accessible from
--     'Graphics.Vulkan.Core10.Handles.ImageView' at the time this
--     descriptor is accessed as defined by the
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#resources-image-layouts-matching-rule image layout matching rules>
--
-- -   If 'Graphics.Vulkan.Core10.Handles.Sampler' is used and the
--     'Graphics.Vulkan.Core10.Enums.Format.Format' of the image is a
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#formats-requiring-sampler-ycbcr-conversion multi-planar format>,
--     the image /must/ have been created with
--     'Graphics.Vulkan.Core10.Enums.ImageCreateFlagBits.IMAGE_CREATE_MUTABLE_FORMAT_BIT',
--     and the @aspectMask@ of the
--     'Graphics.Vulkan.Core10.Handles.ImageView' /must/ be
--     'Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits.IMAGE_ASPECT_PLANE_0_BIT',
--     'Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits.IMAGE_ASPECT_PLANE_1_BIT'
--     or (for three-plane formats only)
--     'Graphics.Vulkan.Core10.Enums.ImageAspectFlagBits.IMAGE_ASPECT_PLANE_2_BIT'
--
-- == Valid Usage (Implicit)
--
-- -   Both of 'Graphics.Vulkan.Core10.Handles.ImageView', and
--     'Graphics.Vulkan.Core10.Handles.Sampler' that are valid handles of
--     non-ignored parameters /must/ have been created, allocated, or
--     retrieved from the same 'Graphics.Vulkan.Core10.Handles.Device'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Enums.ImageLayout.ImageLayout',
-- 'Graphics.Vulkan.Core10.Handles.ImageView',
-- 'Graphics.Vulkan.Core10.Handles.Sampler', 'WriteDescriptorSet'
data DescriptorImageInfo = DescriptorImageInfo
  { -- | 'Graphics.Vulkan.Core10.Handles.Sampler' is a sampler handle, and is
    -- used in descriptor updates for types
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLER'
    -- and
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER'
    -- if the binding being updated does not use immutable samplers.
    sampler :: Sampler
  , -- | 'Graphics.Vulkan.Core10.Handles.ImageView' is an image view handle, and
    -- is used in descriptor updates for types
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLED_IMAGE',
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_IMAGE',
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
    -- and
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INPUT_ATTACHMENT'.
    imageView :: ImageView
  , -- | 'Graphics.Vulkan.Core10.Enums.ImageLayout.ImageLayout' is the layout
    -- that the image subresources accessible from
    -- 'Graphics.Vulkan.Core10.Handles.ImageView' will be in at the time this
    -- descriptor is accessed.
    -- 'Graphics.Vulkan.Core10.Enums.ImageLayout.ImageLayout' is used in
    -- descriptor updates for types
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLED_IMAGE',
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_IMAGE',
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
    -- and
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INPUT_ATTACHMENT'.
    imageLayout :: ImageLayout
  }
  deriving (Typeable)
deriving instance Show DescriptorImageInfo

instance ToCStruct DescriptorImageInfo where
  withCStruct x f = allocaBytesAligned 24 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p DescriptorImageInfo{..} f = do
    poke ((p `plusPtr` 0 :: Ptr Sampler)) (sampler)
    poke ((p `plusPtr` 8 :: Ptr ImageView)) (imageView)
    poke ((p `plusPtr` 16 :: Ptr ImageLayout)) (imageLayout)
    f
  cStructSize = 24
  cStructAlignment = 8
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr Sampler)) (zero)
    poke ((p `plusPtr` 8 :: Ptr ImageView)) (zero)
    poke ((p `plusPtr` 16 :: Ptr ImageLayout)) (zero)
    f

instance FromCStruct DescriptorImageInfo where
  peekCStruct p = do
    sampler <- peek @Sampler ((p `plusPtr` 0 :: Ptr Sampler))
    imageView <- peek @ImageView ((p `plusPtr` 8 :: Ptr ImageView))
    imageLayout <- peek @ImageLayout ((p `plusPtr` 16 :: Ptr ImageLayout))
    pure $ DescriptorImageInfo
             sampler imageView imageLayout

instance Storable DescriptorImageInfo where
  sizeOf ~_ = 24
  alignment ~_ = 8
  peek = peekCStruct
  poke ptr poked = pokeCStruct ptr poked (pure ())

instance Zero DescriptorImageInfo where
  zero = DescriptorImageInfo
           zero
           zero
           zero


-- | VkWriteDescriptorSet - Structure specifying the parameters of a
-- descriptor set write operation
--
-- = Description
--
-- Only one of @pImageInfo@, @pBufferInfo@, or @pTexelBufferView@ members
-- is used according to the descriptor type specified in the
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' member of
-- the containing 'WriteDescriptorSet' structure, or none of them in case
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT',
-- in which case the source data for the descriptor writes is taken from
-- the
-- 'Graphics.Vulkan.Extensions.VK_EXT_inline_uniform_block.WriteDescriptorSetInlineUniformBlockEXT'
-- structure included in the @pNext@ chain of 'WriteDescriptorSet', or if
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_NV',
-- in which case the source data for the descriptor writes is taken from
-- the
-- 'Graphics.Vulkan.Extensions.VK_NV_ray_tracing.WriteDescriptorSetAccelerationStructureNV'
-- structure in the @pNext@ chain of 'WriteDescriptorSet', as specified
-- below.
--
-- If the @dstBinding@ has fewer than @descriptorCount@ array elements
-- remaining starting from @dstArrayElement@, then the remainder will be
-- used to update the subsequent binding - @dstBinding@+1 starting at array
-- element zero. If a binding has a @descriptorCount@ of zero, it is
-- skipped. This behavior applies recursively, with the update affecting
-- consecutive bindings as needed to update all @descriptorCount@
-- descriptors.
--
-- Note
--
-- The same behavior applies to bindings with a descriptor type of
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
-- where @descriptorCount@ specifies the number of bytes to update while
-- @dstArrayElement@ specifies the starting byte offset, thus in this case
-- if the @dstBinding@ has a smaller byte size than the sum of
-- @dstArrayElement@ and @descriptorCount@, then the remainder will be used
-- to update the subsequent binding - @dstBinding@+1 starting at offset
-- zero. This falls out as a special case of the above rule.
--
-- == Valid Usage
--
-- -   @dstBinding@ /must/ be less than or equal to the maximum value of
--     @binding@ of all 'DescriptorSetLayoutBinding' structures specified
--     when @dstSet@’s descriptor set layout was created
--
-- -   @dstBinding@ /must/ be a binding with a non-zero @descriptorCount@
--
-- -   All consecutive bindings updated via a single 'WriteDescriptorSet'
--     structure, except those with a @descriptorCount@ of zero, /must/
--     have identical
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' and
--     @stageFlags@.
--
-- -   All consecutive bindings updated via a single 'WriteDescriptorSet'
--     structure, except those with a @descriptorCount@ of zero, /must/ all
--     either use immutable samplers or /must/ all not use immutable
--     samplers.
--
-- -   'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' /must/
--     match the type of @dstBinding@ within @dstSet@
--
-- -   @dstSet@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.DescriptorSet' handle
--
-- -   The sum of @dstArrayElement@ and @descriptorCount@ /must/ be less
--     than or equal to the number of array elements in the descriptor set
--     binding specified by @dstBinding@, and all applicable consecutive
--     bindings, as described by
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#descriptorsets-updates-consecutive>
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT',
--     @dstArrayElement@ /must/ be an integer multiple of @4@
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT',
--     @descriptorCount@ /must/ be an integer multiple of @4@
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLER',
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLED_IMAGE',
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_IMAGE',
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INPUT_ATTACHMENT',
--     @pImageInfo@ /must/ be a valid pointer to an array of
--     @descriptorCount@ valid 'DescriptorImageInfo' structures
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_TEXEL_BUFFER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_TEXEL_BUFFER',
--     @pTexelBufferView@ /must/ be a valid pointer to an array of
--     @descriptorCount@ valid 'Graphics.Vulkan.Core10.Handles.BufferView'
--     handles
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER',
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER',
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC',
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC',
--     @pBufferInfo@ /must/ be a valid pointer to an array of
--     @descriptorCount@ valid 'DescriptorBufferInfo' structures
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
--     and @dstSet@ was not allocated with a layout that included immutable
--     samplers for @dstBinding@ with
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType', the
--     'Graphics.Vulkan.Core10.Handles.Sampler' member of each element of
--     @pImageInfo@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.Sampler' object
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLED_IMAGE',
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_IMAGE',
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INPUT_ATTACHMENT',
--     the 'Graphics.Vulkan.Core10.Handles.ImageView' and
--     'Graphics.Vulkan.Core10.Enums.ImageLayout.ImageLayout' members of
--     each element of @pImageInfo@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.ImageView' and
--     'Graphics.Vulkan.Core10.Enums.ImageLayout.ImageLayout', respectively
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT',
--     the @pNext@ chain /must/ include a
--     'Graphics.Vulkan.Extensions.VK_EXT_inline_uniform_block.WriteDescriptorSetInlineUniformBlockEXT'
--     structure whose @dataSize@ member equals @descriptorCount@
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_NV',
--     the @pNext@ chain /must/ include a
--     'Graphics.Vulkan.Extensions.VK_NV_ray_tracing.WriteDescriptorSetAccelerationStructureNV'
--     structure whose @accelerationStructureCount@ member equals
--     @descriptorCount@
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLED_IMAGE',
--     then the 'Graphics.Vulkan.Core10.Handles.ImageView' member of each
--     @pImageInfo@ element /must/ have been created without a
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_sampler_ycbcr_conversion.SamplerYcbcrConversionInfo'
--     structure in its @pNext@ chain
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
--     and if any element of @pImageInfo@ has a
--     'Graphics.Vulkan.Core10.Handles.ImageView' member that was created
--     with a
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_sampler_ycbcr_conversion.SamplerYcbcrConversionInfo'
--     structure in its @pNext@ chain, then @dstSet@ /must/ have been
--     allocated with a layout that included immutable samplers for
--     @dstBinding@, and the corresponding immutable sampler /must/ have
--     been created with an /identically defined/
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_sampler_ycbcr_conversion.SamplerYcbcrConversionInfo'
--     object
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
--     and @dstSet@ was allocated with a layout that included immutable
--     samplers for @dstBinding@, then the
--     'Graphics.Vulkan.Core10.Handles.ImageView' member of each element of
--     @pImageInfo@ which corresponds to an immutable sampler that enables
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#samplers-YCbCr-conversion sampler Y′CBCR conversion>
--     /must/ have been created with a
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_sampler_ycbcr_conversion.SamplerYcbcrConversionInfo'
--     structure in its @pNext@ chain with an /identically defined/
--     'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_sampler_ycbcr_conversion.SamplerYcbcrConversionInfo'
--     to the corresponding immutable sampler
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_IMAGE',
--     for each descriptor that will be accessed via load or store
--     operations the
--     'Graphics.Vulkan.Core10.Enums.ImageLayout.ImageLayout' member for
--     corresponding elements of @pImageInfo@ /must/ be
--     'Graphics.Vulkan.Core10.Enums.ImageLayout.IMAGE_LAYOUT_GENERAL'
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC',
--     the @offset@ member of each element of @pBufferInfo@ /must/ be a
--     multiple of
--     'Graphics.Vulkan.Core10.DeviceInitialization.PhysicalDeviceLimits'::@minUniformBufferOffsetAlignment@
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC',
--     the @offset@ member of each element of @pBufferInfo@ /must/ be a
--     multiple of
--     'Graphics.Vulkan.Core10.DeviceInitialization.PhysicalDeviceLimits'::@minStorageBufferOffsetAlignment@
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER',
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC',
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER',
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC',
--     and the 'Graphics.Vulkan.Core10.Handles.Buffer' member of any
--     element of @pBufferInfo@ is the handle of a non-sparse buffer, then
--     that buffer /must/ be bound completely and contiguously to a single
--     'Graphics.Vulkan.Core10.Handles.DeviceMemory' object
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC',
--     the 'Graphics.Vulkan.Core10.Handles.Buffer' member of each element
--     of @pBufferInfo@ /must/ have been created with
--     'Graphics.Vulkan.Core10.Enums.BufferUsageFlagBits.BUFFER_USAGE_UNIFORM_BUFFER_BIT'
--     set
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC',
--     the 'Graphics.Vulkan.Core10.Handles.Buffer' member of each element
--     of @pBufferInfo@ /must/ have been created with
--     'Graphics.Vulkan.Core10.Enums.BufferUsageFlagBits.BUFFER_USAGE_STORAGE_BUFFER_BIT'
--     set
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC',
--     the @range@ member of each element of @pBufferInfo@, or the
--     effective range if @range@ is
--     'Graphics.Vulkan.Core10.APIConstants.WHOLE_SIZE', /must/ be less
--     than or equal to
--     'Graphics.Vulkan.Core10.DeviceInitialization.PhysicalDeviceLimits'::@maxUniformBufferRange@
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC',
--     the @range@ member of each element of @pBufferInfo@, or the
--     effective range if @range@ is
--     'Graphics.Vulkan.Core10.APIConstants.WHOLE_SIZE', /must/ be less
--     than or equal to
--     'Graphics.Vulkan.Core10.DeviceInitialization.PhysicalDeviceLimits'::@maxStorageBufferRange@
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_TEXEL_BUFFER',
--     the 'Graphics.Vulkan.Core10.Handles.Buffer' that each element of
--     @pTexelBufferView@ was created from /must/ have been created with
--     'Graphics.Vulkan.Core10.Enums.BufferUsageFlagBits.BUFFER_USAGE_UNIFORM_TEXEL_BUFFER_BIT'
--     set
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_TEXEL_BUFFER',
--     the 'Graphics.Vulkan.Core10.Handles.Buffer' that each element of
--     @pTexelBufferView@ was created from /must/ have been created with
--     'Graphics.Vulkan.Core10.Enums.BufferUsageFlagBits.BUFFER_USAGE_STORAGE_TEXEL_BUFFER_BIT'
--     set
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_IMAGE'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INPUT_ATTACHMENT',
--     the 'Graphics.Vulkan.Core10.Handles.ImageView' member of each
--     element of @pImageInfo@ /must/ have been created with the identity
--     swizzle
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLED_IMAGE'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
--     the 'Graphics.Vulkan.Core10.Handles.ImageView' member of each
--     element of @pImageInfo@ /must/ have been created with
--     'Graphics.Vulkan.Core10.Enums.ImageUsageFlagBits.IMAGE_USAGE_SAMPLED_BIT'
--     set
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLED_IMAGE'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
--     the 'Graphics.Vulkan.Core10.Enums.ImageLayout.ImageLayout' member of
--     each element of @pImageInfo@ /must/ be a member of the list given in
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#descriptorsets-sampledimage Sampled Image>
--     or
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#descriptorsets-combinedimagesampler Combined Image Sampler>,
--     corresponding to its type
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INPUT_ATTACHMENT',
--     the 'Graphics.Vulkan.Core10.Handles.ImageView' member of each
--     element of @pImageInfo@ /must/ have been created with
--     'Graphics.Vulkan.Core10.Enums.ImageUsageFlagBits.IMAGE_USAGE_INPUT_ATTACHMENT_BIT'
--     set
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_IMAGE',
--     the 'Graphics.Vulkan.Core10.Handles.ImageView' member of each
--     element of @pImageInfo@ /must/ have been created with
--     'Graphics.Vulkan.Core10.Enums.ImageUsageFlagBits.IMAGE_USAGE_STORAGE_BIT'
--     set
--
-- -   All consecutive bindings updated via a single 'WriteDescriptorSet'
--     structure, except those with a @descriptorCount@ of zero, /must/
--     have identical
--     'Graphics.Vulkan.Core12.Enums.DescriptorBindingFlagBits.DescriptorBindingFlagBits'.
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLER',
--     then @dstSet@ /must/ not have been allocated with a layout that
--     included immutable samplers for @dstBinding@
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Graphics.Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET'
--
-- -   Each @pNext@ member of any structure (including this one) in the
--     @pNext@ chain /must/ be either @NULL@ or a pointer to a valid
--     instance of
--     'Graphics.Vulkan.Extensions.VK_NV_ray_tracing.WriteDescriptorSetAccelerationStructureNV'
--     or
--     'Graphics.Vulkan.Extensions.VK_EXT_inline_uniform_block.WriteDescriptorSetInlineUniformBlockEXT'
--
-- -   The @sType@ value of each struct in the @pNext@ chain /must/ be
--     unique
--
-- -   'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' /must/
--     be a valid
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' value
--
-- -   @descriptorCount@ /must/ be greater than @0@
--
-- -   Both of @dstSet@, and the elements of @pTexelBufferView@ that are
--     valid handles of non-ignored parameters /must/ have been created,
--     allocated, or retrieved from the same
--     'Graphics.Vulkan.Core10.Handles.Device'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.BufferView', 'DescriptorBufferInfo',
-- 'DescriptorImageInfo', 'Graphics.Vulkan.Core10.Handles.DescriptorSet',
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType',
-- 'Graphics.Vulkan.Core10.Enums.StructureType.StructureType',
-- 'Graphics.Vulkan.Extensions.VK_KHR_push_descriptor.cmdPushDescriptorSetKHR',
-- 'updateDescriptorSets'
data WriteDescriptorSet (es :: [Type]) = WriteDescriptorSet
  { -- | @pNext@ is @NULL@ or a pointer to an extension-specific structure.
    next :: Chain es
  , -- | @dstSet@ is the destination descriptor set to update.
    dstSet :: DescriptorSet
  , -- | @dstBinding@ is the descriptor binding within that set.
    dstBinding :: Word32
  , -- | @dstArrayElement@ is the starting element in that array. If the
    -- descriptor binding identified by @dstSet@ and @dstBinding@ has a
    -- descriptor type of
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
    -- then @dstArrayElement@ specifies the starting byte offset within the
    -- binding.
    dstArrayElement :: Word32
  , -- | 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is a
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' specifying
    -- the type of each descriptor in @pImageInfo@, @pBufferInfo@, or
    -- @pTexelBufferView@, as described below. It /must/ be the same type as
    -- that specified in 'DescriptorSetLayoutBinding' for @dstSet@ at
    -- @dstBinding@. The type of the descriptor also controls which array the
    -- descriptors are taken from.
    descriptorType :: DescriptorType
  , -- | @pImageInfo@ is a pointer to an array of 'DescriptorImageInfo'
    -- structures or is ignored, as described below.
    imageInfo :: Vector DescriptorImageInfo
  , -- | @pBufferInfo@ is a pointer to an array of 'DescriptorBufferInfo'
    -- structures or is ignored, as described below.
    bufferInfo :: Vector DescriptorBufferInfo
  , -- | @pTexelBufferView@ is a pointer to an array of
    -- 'Graphics.Vulkan.Core10.Handles.BufferView' handles as described in the
    -- <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#resources-buffer-views Buffer Views>
    -- section or is ignored, as described below.
    texelBufferView :: Vector BufferView
  }
  deriving (Typeable)
deriving instance Show (Chain es) => Show (WriteDescriptorSet es)

instance Extensible WriteDescriptorSet where
  extensibleType = STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET
  setNext x next = x{next = next}
  getNext WriteDescriptorSet{..} = next
  extends :: forall e b proxy. Typeable e => proxy e -> (Extends WriteDescriptorSet e => b) -> Maybe b
  extends _ f
    | Just Refl <- eqT @e @WriteDescriptorSetAccelerationStructureNV = Just f
    | Just Refl <- eqT @e @WriteDescriptorSetInlineUniformBlockEXT = Just f
    | otherwise = Nothing

instance PokeChain es => ToCStruct (WriteDescriptorSet es) where
  withCStruct x f = allocaBytesAligned 64 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p WriteDescriptorSet{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET)
    pNext'' <- fmap castPtr . ContT $ withChain (next)
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext''
    lift $ poke ((p `plusPtr` 16 :: Ptr DescriptorSet)) (dstSet)
    lift $ poke ((p `plusPtr` 24 :: Ptr Word32)) (dstBinding)
    lift $ poke ((p `plusPtr` 28 :: Ptr Word32)) (dstArrayElement)
    let pImageInfoLength = Data.Vector.length $ (imageInfo)
    let pBufferInfoLength = Data.Vector.length $ (bufferInfo)
    lift $ unless (pBufferInfoLength == pImageInfoLength) $
      throwIO $ IOError Nothing InvalidArgument "" "pBufferInfo and pImageInfo must have the same length" Nothing Nothing
    let pTexelBufferViewLength = Data.Vector.length $ (texelBufferView)
    lift $ unless (pTexelBufferViewLength == pImageInfoLength) $
      throwIO $ IOError Nothing InvalidArgument "" "pTexelBufferView and pImageInfo must have the same length" Nothing Nothing
    lift $ poke ((p `plusPtr` 32 :: Ptr Word32)) ((fromIntegral pImageInfoLength :: Word32))
    lift $ poke ((p `plusPtr` 36 :: Ptr DescriptorType)) (descriptorType)
    pPImageInfo' <- ContT $ allocaBytesAligned @DescriptorImageInfo ((Data.Vector.length (imageInfo)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPImageInfo' `plusPtr` (24 * (i)) :: Ptr DescriptorImageInfo) (e) . ($ ())) (imageInfo)
    lift $ poke ((p `plusPtr` 40 :: Ptr (Ptr DescriptorImageInfo))) (pPImageInfo')
    pPBufferInfo' <- ContT $ allocaBytesAligned @DescriptorBufferInfo ((Data.Vector.length (bufferInfo)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBufferInfo' `plusPtr` (24 * (i)) :: Ptr DescriptorBufferInfo) (e) . ($ ())) (bufferInfo)
    lift $ poke ((p `plusPtr` 48 :: Ptr (Ptr DescriptorBufferInfo))) (pPBufferInfo')
    pPTexelBufferView' <- ContT $ allocaBytesAligned @BufferView ((Data.Vector.length (texelBufferView)) * 8) 8
    lift $ Data.Vector.imapM_ (\i e -> poke (pPTexelBufferView' `plusPtr` (8 * (i)) :: Ptr BufferView) (e)) (texelBufferView)
    lift $ poke ((p `plusPtr` 56 :: Ptr (Ptr BufferView))) (pPTexelBufferView')
    lift $ f
  cStructSize = 64
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET)
    pNext' <- fmap castPtr . ContT $ withZeroChain @es
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext'
    lift $ poke ((p `plusPtr` 16 :: Ptr DescriptorSet)) (zero)
    lift $ poke ((p `plusPtr` 24 :: Ptr Word32)) (zero)
    lift $ poke ((p `plusPtr` 28 :: Ptr Word32)) (zero)
    lift $ poke ((p `plusPtr` 36 :: Ptr DescriptorType)) (zero)
    pPImageInfo' <- ContT $ allocaBytesAligned @DescriptorImageInfo ((Data.Vector.length (mempty)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPImageInfo' `plusPtr` (24 * (i)) :: Ptr DescriptorImageInfo) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 40 :: Ptr (Ptr DescriptorImageInfo))) (pPImageInfo')
    pPBufferInfo' <- ContT $ allocaBytesAligned @DescriptorBufferInfo ((Data.Vector.length (mempty)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBufferInfo' `plusPtr` (24 * (i)) :: Ptr DescriptorBufferInfo) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 48 :: Ptr (Ptr DescriptorBufferInfo))) (pPBufferInfo')
    pPTexelBufferView' <- ContT $ allocaBytesAligned @BufferView ((Data.Vector.length (mempty)) * 8) 8
    lift $ Data.Vector.imapM_ (\i e -> poke (pPTexelBufferView' `plusPtr` (8 * (i)) :: Ptr BufferView) (e)) (mempty)
    lift $ poke ((p `plusPtr` 56 :: Ptr (Ptr BufferView))) (pPTexelBufferView')
    lift $ f

instance PeekChain es => FromCStruct (WriteDescriptorSet es) where
  peekCStruct p = do
    pNext <- peek @(Ptr ()) ((p `plusPtr` 8 :: Ptr (Ptr ())))
    next <- peekChain (castPtr pNext)
    dstSet <- peek @DescriptorSet ((p `plusPtr` 16 :: Ptr DescriptorSet))
    dstBinding <- peek @Word32 ((p `plusPtr` 24 :: Ptr Word32))
    dstArrayElement <- peek @Word32 ((p `plusPtr` 28 :: Ptr Word32))
    descriptorType <- peek @DescriptorType ((p `plusPtr` 36 :: Ptr DescriptorType))
    descriptorCount <- peek @Word32 ((p `plusPtr` 32 :: Ptr Word32))
    pImageInfo <- peek @(Ptr DescriptorImageInfo) ((p `plusPtr` 40 :: Ptr (Ptr DescriptorImageInfo)))
    pImageInfo' <- generateM (fromIntegral descriptorCount) (\i -> peekCStruct @DescriptorImageInfo ((pImageInfo `advancePtrBytes` (24 * (i)) :: Ptr DescriptorImageInfo)))
    pBufferInfo <- peek @(Ptr DescriptorBufferInfo) ((p `plusPtr` 48 :: Ptr (Ptr DescriptorBufferInfo)))
    pBufferInfo' <- generateM (fromIntegral descriptorCount) (\i -> peekCStruct @DescriptorBufferInfo ((pBufferInfo `advancePtrBytes` (24 * (i)) :: Ptr DescriptorBufferInfo)))
    pTexelBufferView <- peek @(Ptr BufferView) ((p `plusPtr` 56 :: Ptr (Ptr BufferView)))
    pTexelBufferView' <- generateM (fromIntegral descriptorCount) (\i -> peek @BufferView ((pTexelBufferView `advancePtrBytes` (8 * (i)) :: Ptr BufferView)))
    pure $ WriteDescriptorSet
             next dstSet dstBinding dstArrayElement descriptorType pImageInfo' pBufferInfo' pTexelBufferView'

instance es ~ '[] => Zero (WriteDescriptorSet es) where
  zero = WriteDescriptorSet
           ()
           zero
           zero
           zero
           zero
           mempty
           mempty
           mempty


-- | VkCopyDescriptorSet - Structure specifying a copy descriptor set
-- operation
--
-- == Valid Usage
--
-- -   @srcBinding@ /must/ be a valid binding within @srcSet@
--
-- -   The sum of @srcArrayElement@ and @descriptorCount@ /must/ be less
--     than or equal to the number of array elements in the descriptor set
--     binding specified by @srcBinding@, and all applicable consecutive
--     bindings, as described by
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#descriptorsets-updates-consecutive>
--
-- -   @dstBinding@ /must/ be a valid binding within @dstSet@
--
-- -   The sum of @dstArrayElement@ and @descriptorCount@ /must/ be less
--     than or equal to the number of array elements in the descriptor set
--     binding specified by @dstBinding@, and all applicable consecutive
--     bindings, as described by
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#descriptorsets-updates-consecutive>
--
-- -   The type of @dstBinding@ within @dstSet@ /must/ be equal to the type
--     of @srcBinding@ within @srcSet@
--
-- -   If @srcSet@ is equal to @dstSet@, then the source and destination
--     ranges of descriptors /must/ not overlap, where the ranges /may/
--     include array elements from consecutive bindings as described by
--     <https://www.khronos.org/registry/vulkan/specs/1.2-extensions/html/vkspec.html#descriptorsets-updates-consecutive>
--
-- -   If the descriptor type of the descriptor set binding specified by
--     @srcBinding@ is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT',
--     @srcArrayElement@ /must/ be an integer multiple of @4@
--
-- -   If the descriptor type of the descriptor set binding specified by
--     @dstBinding@ is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT',
--     @dstArrayElement@ /must/ be an integer multiple of @4@
--
-- -   If the descriptor type of the descriptor set binding specified by
--     either @srcBinding@ or @dstBinding@ is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT',
--     @descriptorCount@ /must/ be an integer multiple of @4@
--
-- -   If @srcSet@’s layout was created with the
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT'
--     flag set, then @dstSet@’s layout /must/ also have been created with
--     the
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT'
--     flag set
--
-- -   If @srcSet@’s layout was created without the
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT'
--     flag set, then @dstSet@’s layout /must/ also have been created
--     without the
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT'
--     flag set
--
-- -   If the descriptor pool from which @srcSet@ was allocated was created
--     with the
--     'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT'
--     flag set, then the descriptor pool from which @dstSet@ was allocated
--     /must/ also have been created with the
--     'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT'
--     flag set
--
-- -   If the descriptor pool from which @srcSet@ was allocated was created
--     without the
--     'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT'
--     flag set, then the descriptor pool from which @dstSet@ was allocated
--     /must/ also have been created without the
--     'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT'
--     flag set
--
-- -   If the descriptor type of the descriptor set binding specified by
--     @dstBinding@ is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLER',
--     then @dstSet@ /must/ not have been allocated with a layout that
--     included immutable samplers for @dstBinding@
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Graphics.Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_COPY_DESCRIPTOR_SET'
--
-- -   @pNext@ /must/ be @NULL@
--
-- -   @srcSet@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.DescriptorSet' handle
--
-- -   @dstSet@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.DescriptorSet' handle
--
-- -   Both of @dstSet@, and @srcSet@ /must/ have been created, allocated,
--     or retrieved from the same 'Graphics.Vulkan.Core10.Handles.Device'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.DescriptorSet',
-- 'Graphics.Vulkan.Core10.Enums.StructureType.StructureType',
-- 'updateDescriptorSets'
data CopyDescriptorSet = CopyDescriptorSet
  { -- | @srcSet@, @srcBinding@, and @srcArrayElement@ are the source set,
    -- binding, and array element, respectively. If the descriptor binding
    -- identified by @srcSet@ and @srcBinding@ has a descriptor type of
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
    -- then @srcArrayElement@ specifies the starting byte offset within the
    -- binding to copy from.
    srcSet :: DescriptorSet
  , -- No documentation found for Nested "VkCopyDescriptorSet" "srcBinding"
    srcBinding :: Word32
  , -- No documentation found for Nested "VkCopyDescriptorSet" "srcArrayElement"
    srcArrayElement :: Word32
  , -- | @dstSet@, @dstBinding@, and @dstArrayElement@ are the destination set,
    -- binding, and array element, respectively. If the descriptor binding
    -- identified by @dstSet@ and @dstBinding@ has a descriptor type of
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
    -- then @dstArrayElement@ specifies the starting byte offset within the
    -- binding to copy to.
    dstSet :: DescriptorSet
  , -- No documentation found for Nested "VkCopyDescriptorSet" "dstBinding"
    dstBinding :: Word32
  , -- No documentation found for Nested "VkCopyDescriptorSet" "dstArrayElement"
    dstArrayElement :: Word32
  , -- | @descriptorCount@ is the number of descriptors to copy from the source
    -- to destination. If @descriptorCount@ is greater than the number of
    -- remaining array elements in the source or destination binding, those
    -- affect consecutive bindings in a manner similar to 'WriteDescriptorSet'
    -- above. If the descriptor binding identified by @srcSet@ and @srcBinding@
    -- has a descriptor type of
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
    -- then @descriptorCount@ specifies the number of bytes to copy and the
    -- remaining array elements in the source or destination binding refer to
    -- the remaining number of bytes in those.
    descriptorCount :: Word32
  }
  deriving (Typeable)
deriving instance Show CopyDescriptorSet

instance ToCStruct CopyDescriptorSet where
  withCStruct x f = allocaBytesAligned 56 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p CopyDescriptorSet{..} f = do
    poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_COPY_DESCRIPTOR_SET)
    poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    poke ((p `plusPtr` 16 :: Ptr DescriptorSet)) (srcSet)
    poke ((p `plusPtr` 24 :: Ptr Word32)) (srcBinding)
    poke ((p `plusPtr` 28 :: Ptr Word32)) (srcArrayElement)
    poke ((p `plusPtr` 32 :: Ptr DescriptorSet)) (dstSet)
    poke ((p `plusPtr` 40 :: Ptr Word32)) (dstBinding)
    poke ((p `plusPtr` 44 :: Ptr Word32)) (dstArrayElement)
    poke ((p `plusPtr` 48 :: Ptr Word32)) (descriptorCount)
    f
  cStructSize = 56
  cStructAlignment = 8
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_COPY_DESCRIPTOR_SET)
    poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) (nullPtr)
    poke ((p `plusPtr` 16 :: Ptr DescriptorSet)) (zero)
    poke ((p `plusPtr` 24 :: Ptr Word32)) (zero)
    poke ((p `plusPtr` 28 :: Ptr Word32)) (zero)
    poke ((p `plusPtr` 32 :: Ptr DescriptorSet)) (zero)
    poke ((p `plusPtr` 40 :: Ptr Word32)) (zero)
    poke ((p `plusPtr` 44 :: Ptr Word32)) (zero)
    poke ((p `plusPtr` 48 :: Ptr Word32)) (zero)
    f

instance FromCStruct CopyDescriptorSet where
  peekCStruct p = do
    srcSet <- peek @DescriptorSet ((p `plusPtr` 16 :: Ptr DescriptorSet))
    srcBinding <- peek @Word32 ((p `plusPtr` 24 :: Ptr Word32))
    srcArrayElement <- peek @Word32 ((p `plusPtr` 28 :: Ptr Word32))
    dstSet <- peek @DescriptorSet ((p `plusPtr` 32 :: Ptr DescriptorSet))
    dstBinding <- peek @Word32 ((p `plusPtr` 40 :: Ptr Word32))
    dstArrayElement <- peek @Word32 ((p `plusPtr` 44 :: Ptr Word32))
    descriptorCount <- peek @Word32 ((p `plusPtr` 48 :: Ptr Word32))
    pure $ CopyDescriptorSet
             srcSet srcBinding srcArrayElement dstSet dstBinding dstArrayElement descriptorCount

instance Storable CopyDescriptorSet where
  sizeOf ~_ = 56
  alignment ~_ = 8
  peek = peekCStruct
  poke ptr poked = pokeCStruct ptr poked (pure ())

instance Zero CopyDescriptorSet where
  zero = CopyDescriptorSet
           zero
           zero
           zero
           zero
           zero
           zero
           zero


-- | VkDescriptorSetLayoutBinding - Structure specifying a descriptor set
-- layout binding
--
-- = Description
--
-- -   @pImmutableSamplers@ affects initialization of samplers. If
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType'
--     specifies a
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER'
--     type descriptor, then @pImmutableSamplers@ /can/ be used to
--     initialize a set of /immutable samplers/. Immutable samplers are
--     permanently bound into the set layout and /must/ not be changed;
--     updating a
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLER'
--     descriptor with immutable samplers is not allowed and updates to a
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER'
--     descriptor with immutable samplers does not modify the samplers (the
--     image views are updated, but the sampler updates are ignored). If
--     @pImmutableSamplers@ is not @NULL@, then it points to an array of
--     sampler handles that will be copied into the set layout and used for
--     the corresponding binding. Only the sampler handles are copied; the
--     sampler objects /must/ not be destroyed before the final use of the
--     set layout and any descriptor pools and sets created using it. If
--     @pImmutableSamplers@ is @NULL@, then the sampler slots are dynamic
--     and sampler handles /must/ be bound into descriptor sets using this
--     layout. If
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is not
--     one of these descriptor types, then @pImmutableSamplers@ is ignored.
--
-- The above layout definition allows the descriptor bindings to be
-- specified sparsely such that not all binding numbers between 0 and the
-- maximum binding number need to be specified in the @pBindings@ array.
-- Bindings that are not specified have a @descriptorCount@ and
-- @stageFlags@ of zero, and the value of
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
-- undefined. However, all binding numbers between 0 and the maximum
-- binding number in the 'DescriptorSetLayoutCreateInfo'::@pBindings@ array
-- /may/ consume memory in the descriptor set layout even if not all
-- descriptor bindings are used, though it /should/ not consume additional
-- memory from the descriptor pool.
--
-- Note
--
-- The maximum binding number specified /should/ be as compact as possible
-- to avoid wasted memory.
--
-- == Valid Usage
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_SAMPLER'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER',
--     and @descriptorCount@ is not @0@ and @pImmutableSamplers@ is not
--     @NULL@, @pImmutableSamplers@ /must/ be a valid pointer to an array
--     of @descriptorCount@ valid 'Graphics.Vulkan.Core10.Handles.Sampler'
--     handles
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
--     then @descriptorCount@ /must/ be a multiple of @4@
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
--     then @descriptorCount@ /must/ be less than or equal to
--     'Graphics.Vulkan.Extensions.VK_EXT_inline_uniform_block.PhysicalDeviceInlineUniformBlockPropertiesEXT'::@maxInlineUniformBlockSize@
--
-- -   If @descriptorCount@ is not @0@, @stageFlags@ /must/ be a valid
--     combination of
--     'Graphics.Vulkan.Core10.Enums.ShaderStageFlagBits.ShaderStageFlagBits'
--     values
--
-- -   If 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INPUT_ATTACHMENT'
--     and @descriptorCount@ is not @0@, then @stageFlags@ /must/ be @0@ or
--     'Graphics.Vulkan.Core10.Enums.ShaderStageFlagBits.SHADER_STAGE_FRAGMENT_BIT'
--
-- == Valid Usage (Implicit)
--
-- -   'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' /must/
--     be a valid
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' value
--
-- = See Also
--
-- 'DescriptorSetLayoutCreateInfo',
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType',
-- 'Graphics.Vulkan.Core10.Handles.Sampler',
-- 'Graphics.Vulkan.Core10.Enums.ShaderStageFlagBits.ShaderStageFlags'
data DescriptorSetLayoutBinding = DescriptorSetLayoutBinding
  { -- | @binding@ is the binding number of this entry and corresponds to a
    -- resource of the same binding number in the shader stages.
    binding :: Word32
  , -- | 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' is a
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' specifying
    -- which type of resource descriptors are used for this binding.
    descriptorType :: DescriptorType
  , -- | @stageFlags@ member is a bitmask of
    -- 'Graphics.Vulkan.Core10.Enums.ShaderStageFlagBits.ShaderStageFlagBits'
    -- specifying which pipeline shader stages /can/ access a resource for this
    -- binding.
    -- 'Graphics.Vulkan.Core10.Enums.ShaderStageFlagBits.SHADER_STAGE_ALL' is a
    -- shorthand specifying that all defined shader stages, including any
    -- additional stages defined by extensions, /can/ access the resource.
    --
    -- If a shader stage is not included in @stageFlags@, then a resource
    -- /must/ not be accessed from that stage via this binding within any
    -- pipeline using the set layout. Other than input attachments which are
    -- limited to the fragment shader, there are no limitations on what
    -- combinations of stages /can/ use a descriptor binding, and in particular
    -- a binding /can/ be used by both graphics stages and the compute stage.
    stageFlags :: ShaderStageFlags
  , -- No documentation found for Nested "VkDescriptorSetLayoutBinding" "pImmutableSamplers"
    immutableSamplers :: Either Word32 (Vector Sampler)
  }
  deriving (Typeable)
deriving instance Show DescriptorSetLayoutBinding

instance ToCStruct DescriptorSetLayoutBinding where
  withCStruct x f = allocaBytesAligned 24 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p DescriptorSetLayoutBinding{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr Word32)) (binding)
    lift $ poke ((p `plusPtr` 4 :: Ptr DescriptorType)) (descriptorType)
    lift $ poke ((p `plusPtr` 8 :: Ptr Word32)) ((fromIntegral (either id (fromIntegral . Data.Vector.length) (immutableSamplers)) :: Word32))
    lift $ poke ((p `plusPtr` 12 :: Ptr ShaderStageFlags)) (stageFlags)
    pImmutableSamplers'' <- case (immutableSamplers) of
      Left _ -> pure nullPtr
      Right v -> do
        pPImmutableSamplers' <- ContT $ allocaBytesAligned @Sampler ((Data.Vector.length (v)) * 8) 8
        lift $ Data.Vector.imapM_ (\i e -> poke (pPImmutableSamplers' `plusPtr` (8 * (i)) :: Ptr Sampler) (e)) (v)
        pure $ pPImmutableSamplers'
    lift $ poke ((p `plusPtr` 16 :: Ptr (Ptr Sampler))) pImmutableSamplers''
    lift $ f
  cStructSize = 24
  cStructAlignment = 8
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr Word32)) (zero)
    poke ((p `plusPtr` 4 :: Ptr DescriptorType)) (zero)
    poke ((p `plusPtr` 12 :: Ptr ShaderStageFlags)) (zero)
    f

instance FromCStruct DescriptorSetLayoutBinding where
  peekCStruct p = do
    binding <- peek @Word32 ((p `plusPtr` 0 :: Ptr Word32))
    descriptorType <- peek @DescriptorType ((p `plusPtr` 4 :: Ptr DescriptorType))
    stageFlags <- peek @ShaderStageFlags ((p `plusPtr` 12 :: Ptr ShaderStageFlags))
    descriptorCount <- peek @Word32 ((p `plusPtr` 8 :: Ptr Word32))
    pImmutableSamplers <- peek @(Ptr Sampler) ((p `plusPtr` 16 :: Ptr (Ptr Sampler)))
    pImmutableSamplers' <- maybePeek (\j -> generateM (fromIntegral descriptorCount) (\i -> peek @Sampler (((j) `advancePtrBytes` (8 * (i)) :: Ptr Sampler)))) pImmutableSamplers
    let pImmutableSamplers'' = maybe (Left descriptorCount) Right pImmutableSamplers'
    pure $ DescriptorSetLayoutBinding
             binding descriptorType stageFlags pImmutableSamplers''

instance Zero DescriptorSetLayoutBinding where
  zero = DescriptorSetLayoutBinding
           zero
           zero
           zero
           (Left 0)


-- | VkDescriptorSetLayoutCreateInfo - Structure specifying parameters of a
-- newly created descriptor set layout
--
-- == Valid Usage
--
-- -   The 'DescriptorSetLayoutBinding'::@binding@ members of the elements
--     of the @pBindings@ array /must/ each have different values.
--
-- -   If 'Graphics.Vulkan.Core10.BaseType.Flags' contains
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_PUSH_DESCRIPTOR_BIT_KHR',
--     then all elements of @pBindings@ /must/ not have a
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' of
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC'
--
-- -   If 'Graphics.Vulkan.Core10.BaseType.Flags' contains
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_PUSH_DESCRIPTOR_BIT_KHR',
--     then all elements of @pBindings@ /must/ not have a
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' of
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
--
-- -   If 'Graphics.Vulkan.Core10.BaseType.Flags' contains
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_PUSH_DESCRIPTOR_BIT_KHR',
--     then the total number of elements of all bindings /must/ be less
--     than or equal to
--     'Graphics.Vulkan.Extensions.VK_KHR_push_descriptor.PhysicalDevicePushDescriptorPropertiesKHR'::@maxPushDescriptors@
--
-- -   If any binding has the
--     'Graphics.Vulkan.Core12.Enums.DescriptorBindingFlagBits.DESCRIPTOR_BINDING_UPDATE_AFTER_BIND_BIT'
--     bit set, 'Graphics.Vulkan.Core10.BaseType.Flags' /must/ include
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT'
--
-- -   If any binding has the
--     'Graphics.Vulkan.Core12.Enums.DescriptorBindingFlagBits.DESCRIPTOR_BINDING_UPDATE_AFTER_BIND_BIT'
--     bit set, then all bindings /must/ not have
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' of
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC'
--     or
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC'
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Graphics.Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO'
--
-- -   @pNext@ /must/ be @NULL@ or a pointer to a valid instance of
--     'Graphics.Vulkan.Core12.Promoted_From_VK_EXT_descriptor_indexing.DescriptorSetLayoutBindingFlagsCreateInfo'
--
-- -   The @sType@ value of each struct in the @pNext@ chain /must/ be
--     unique
--
-- -   'Graphics.Vulkan.Core10.BaseType.Flags' /must/ be a valid
--     combination of
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DescriptorSetLayoutCreateFlagBits'
--     values
--
-- -   If @bindingCount@ is not @0@, @pBindings@ /must/ be a valid pointer
--     to an array of @bindingCount@ valid 'DescriptorSetLayoutBinding'
--     structures
--
-- = See Also
--
-- 'DescriptorSetLayoutBinding',
-- 'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DescriptorSetLayoutCreateFlags',
-- 'Graphics.Vulkan.Core10.Enums.StructureType.StructureType',
-- 'createDescriptorSetLayout',
-- 'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_maintenance3.getDescriptorSetLayoutSupport',
-- 'Graphics.Vulkan.Extensions.VK_KHR_maintenance3.getDescriptorSetLayoutSupportKHR'
data DescriptorSetLayoutCreateInfo (es :: [Type]) = DescriptorSetLayoutCreateInfo
  { -- | @pNext@ is @NULL@ or a pointer to an extension-specific structure.
    next :: Chain es
  , -- | 'Graphics.Vulkan.Core10.BaseType.Flags' is a bitmask of
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DescriptorSetLayoutCreateFlagBits'
    -- specifying options for descriptor set layout creation.
    flags :: DescriptorSetLayoutCreateFlags
  , -- | @pBindings@ is a pointer to an array of 'DescriptorSetLayoutBinding'
    -- structures.
    bindings :: Vector DescriptorSetLayoutBinding
  }
  deriving (Typeable)
deriving instance Show (Chain es) => Show (DescriptorSetLayoutCreateInfo es)

instance Extensible DescriptorSetLayoutCreateInfo where
  extensibleType = STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO
  setNext x next = x{next = next}
  getNext DescriptorSetLayoutCreateInfo{..} = next
  extends :: forall e b proxy. Typeable e => proxy e -> (Extends DescriptorSetLayoutCreateInfo e => b) -> Maybe b
  extends _ f
    | Just Refl <- eqT @e @DescriptorSetLayoutBindingFlagsCreateInfo = Just f
    | otherwise = Nothing

instance PokeChain es => ToCStruct (DescriptorSetLayoutCreateInfo es) where
  withCStruct x f = allocaBytesAligned 32 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p DescriptorSetLayoutCreateInfo{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO)
    pNext'' <- fmap castPtr . ContT $ withChain (next)
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext''
    lift $ poke ((p `plusPtr` 16 :: Ptr DescriptorSetLayoutCreateFlags)) (flags)
    lift $ poke ((p `plusPtr` 20 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (bindings)) :: Word32))
    pPBindings' <- ContT $ allocaBytesAligned @DescriptorSetLayoutBinding ((Data.Vector.length (bindings)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBindings' `plusPtr` (24 * (i)) :: Ptr DescriptorSetLayoutBinding) (e) . ($ ())) (bindings)
    lift $ poke ((p `plusPtr` 24 :: Ptr (Ptr DescriptorSetLayoutBinding))) (pPBindings')
    lift $ f
  cStructSize = 32
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO)
    pNext' <- fmap castPtr . ContT $ withZeroChain @es
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext'
    pPBindings' <- ContT $ allocaBytesAligned @DescriptorSetLayoutBinding ((Data.Vector.length (mempty)) * 24) 8
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPBindings' `plusPtr` (24 * (i)) :: Ptr DescriptorSetLayoutBinding) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 24 :: Ptr (Ptr DescriptorSetLayoutBinding))) (pPBindings')
    lift $ f

instance PeekChain es => FromCStruct (DescriptorSetLayoutCreateInfo es) where
  peekCStruct p = do
    pNext <- peek @(Ptr ()) ((p `plusPtr` 8 :: Ptr (Ptr ())))
    next <- peekChain (castPtr pNext)
    flags <- peek @DescriptorSetLayoutCreateFlags ((p `plusPtr` 16 :: Ptr DescriptorSetLayoutCreateFlags))
    bindingCount <- peek @Word32 ((p `plusPtr` 20 :: Ptr Word32))
    pBindings <- peek @(Ptr DescriptorSetLayoutBinding) ((p `plusPtr` 24 :: Ptr (Ptr DescriptorSetLayoutBinding)))
    pBindings' <- generateM (fromIntegral bindingCount) (\i -> peekCStruct @DescriptorSetLayoutBinding ((pBindings `advancePtrBytes` (24 * (i)) :: Ptr DescriptorSetLayoutBinding)))
    pure $ DescriptorSetLayoutCreateInfo
             next flags pBindings'

instance es ~ '[] => Zero (DescriptorSetLayoutCreateInfo es) where
  zero = DescriptorSetLayoutCreateInfo
           ()
           zero
           mempty


-- | VkDescriptorPoolSize - Structure specifying descriptor pool size
--
-- = Description
--
-- Note
--
-- When creating a descriptor pool that will contain descriptors for
-- combined image samplers of multi-planar formats, an application needs to
-- account for non-trivial descriptor consumption when choosing the
-- @descriptorCount@ value, as indicated by
-- 'Graphics.Vulkan.Core11.Promoted_From_VK_KHR_sampler_ycbcr_conversion.SamplerYcbcrConversionImageFormatProperties'::@combinedImageSamplerDescriptorCount@.
--
-- == Valid Usage
--
-- -   @descriptorCount@ /must/ be greater than @0@
--
-- -   If @type@ is
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
--     then @descriptorCount@ /must/ be a multiple of @4@
--
-- == Valid Usage (Implicit)
--
-- -   @type@ /must/ be a valid
--     'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType' value
--
-- = See Also
--
-- 'DescriptorPoolCreateInfo',
-- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DescriptorType'
data DescriptorPoolSize = DescriptorPoolSize
  { -- | @type@ is the type of descriptor.
    type' :: DescriptorType
  , -- | @descriptorCount@ is the number of descriptors of that type to allocate.
    -- If @type@ is
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorType.DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT'
    -- then @descriptorCount@ is the number of bytes to allocate for
    -- descriptors of this type.
    descriptorCount :: Word32
  }
  deriving (Typeable)
deriving instance Show DescriptorPoolSize

instance ToCStruct DescriptorPoolSize where
  withCStruct x f = allocaBytesAligned 8 4 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p DescriptorPoolSize{..} f = do
    poke ((p `plusPtr` 0 :: Ptr DescriptorType)) (type')
    poke ((p `plusPtr` 4 :: Ptr Word32)) (descriptorCount)
    f
  cStructSize = 8
  cStructAlignment = 4
  pokeZeroCStruct p f = do
    poke ((p `plusPtr` 0 :: Ptr DescriptorType)) (zero)
    poke ((p `plusPtr` 4 :: Ptr Word32)) (zero)
    f

instance FromCStruct DescriptorPoolSize where
  peekCStruct p = do
    type' <- peek @DescriptorType ((p `plusPtr` 0 :: Ptr DescriptorType))
    descriptorCount <- peek @Word32 ((p `plusPtr` 4 :: Ptr Word32))
    pure $ DescriptorPoolSize
             type' descriptorCount

instance Storable DescriptorPoolSize where
  sizeOf ~_ = 8
  alignment ~_ = 4
  peek = peekCStruct
  poke ptr poked = pokeCStruct ptr poked (pure ())

instance Zero DescriptorPoolSize where
  zero = DescriptorPoolSize
           zero
           zero


-- | VkDescriptorPoolCreateInfo - Structure specifying parameters of a newly
-- created descriptor pool
--
-- = Description
--
-- If multiple 'DescriptorPoolSize' structures appear in the @pPoolSizes@
-- array then the pool will be created with enough storage for the total
-- number of descriptors of each type.
--
-- Fragmentation of a descriptor pool is possible and /may/ lead to
-- descriptor set allocation failures. A failure due to fragmentation is
-- defined as failing a descriptor set allocation despite the sum of all
-- outstanding descriptor set allocations from the pool plus the requested
-- allocation requiring no more than the total number of descriptors
-- requested at pool creation. Implementations provide certain guarantees
-- of when fragmentation /must/ not cause allocation failure, as described
-- below.
--
-- If a descriptor pool has not had any descriptor sets freed since it was
-- created or most recently reset then fragmentation /must/ not cause an
-- allocation failure (note that this is always the case for a pool created
-- without the
-- 'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DESCRIPTOR_POOL_CREATE_FREE_DESCRIPTOR_SET_BIT'
-- bit set). Additionally, if all sets allocated from the pool since it was
-- created or most recently reset use the same number of descriptors (of
-- each type) and the requested allocation also uses that same number of
-- descriptors (of each type), then fragmentation /must/ not cause an
-- allocation failure.
--
-- If an allocation failure occurs due to fragmentation, an application
-- /can/ create an additional descriptor pool to perform further descriptor
-- set allocations.
--
-- If 'Graphics.Vulkan.Core10.BaseType.Flags' has the
-- 'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT'
-- bit set, descriptor pool creation /may/ fail with the error
-- 'Graphics.Vulkan.Core10.Enums.Result.ERROR_FRAGMENTATION' if the total
-- number of descriptors across all pools (including this one) created with
-- this bit set exceeds @maxUpdateAfterBindDescriptorsInAllPools@, or if
-- fragmentation of the underlying hardware resources occurs.
--
-- == Valid Usage
--
-- -   @maxSets@ /must/ be greater than @0@
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Graphics.Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO'
--
-- -   @pNext@ /must/ be @NULL@ or a pointer to a valid instance of
--     'Graphics.Vulkan.Extensions.VK_EXT_inline_uniform_block.DescriptorPoolInlineUniformBlockCreateInfoEXT'
--
-- -   The @sType@ value of each struct in the @pNext@ chain /must/ be
--     unique
--
-- -   'Graphics.Vulkan.Core10.BaseType.Flags' /must/ be a valid
--     combination of
--     'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DescriptorPoolCreateFlagBits'
--     values
--
-- -   @pPoolSizes@ /must/ be a valid pointer to an array of
--     @poolSizeCount@ valid 'DescriptorPoolSize' structures
--
-- -   @poolSizeCount@ /must/ be greater than @0@
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DescriptorPoolCreateFlags',
-- 'DescriptorPoolSize',
-- 'Graphics.Vulkan.Core10.Enums.StructureType.StructureType',
-- 'createDescriptorPool'
data DescriptorPoolCreateInfo (es :: [Type]) = DescriptorPoolCreateInfo
  { -- | @pNext@ is @NULL@ or a pointer to an extension-specific structure.
    next :: Chain es
  , -- | 'Graphics.Vulkan.Core10.BaseType.Flags' is a bitmask of
    -- 'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DescriptorPoolCreateFlagBits'
    -- specifying certain supported operations on the pool.
    flags :: DescriptorPoolCreateFlags
  , -- | @maxSets@ is the maximum number of descriptor sets that /can/ be
    -- allocated from the pool.
    maxSets :: Word32
  , -- | @pPoolSizes@ is a pointer to an array of 'DescriptorPoolSize'
    -- structures, each containing a descriptor type and number of descriptors
    -- of that type to be allocated in the pool.
    poolSizes :: Vector DescriptorPoolSize
  }
  deriving (Typeable)
deriving instance Show (Chain es) => Show (DescriptorPoolCreateInfo es)

instance Extensible DescriptorPoolCreateInfo where
  extensibleType = STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO
  setNext x next = x{next = next}
  getNext DescriptorPoolCreateInfo{..} = next
  extends :: forall e b proxy. Typeable e => proxy e -> (Extends DescriptorPoolCreateInfo e => b) -> Maybe b
  extends _ f
    | Just Refl <- eqT @e @DescriptorPoolInlineUniformBlockCreateInfoEXT = Just f
    | otherwise = Nothing

instance PokeChain es => ToCStruct (DescriptorPoolCreateInfo es) where
  withCStruct x f = allocaBytesAligned 40 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p DescriptorPoolCreateInfo{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO)
    pNext'' <- fmap castPtr . ContT $ withChain (next)
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext''
    lift $ poke ((p `plusPtr` 16 :: Ptr DescriptorPoolCreateFlags)) (flags)
    lift $ poke ((p `plusPtr` 20 :: Ptr Word32)) (maxSets)
    lift $ poke ((p `plusPtr` 24 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (poolSizes)) :: Word32))
    pPPoolSizes' <- ContT $ allocaBytesAligned @DescriptorPoolSize ((Data.Vector.length (poolSizes)) * 8) 4
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPPoolSizes' `plusPtr` (8 * (i)) :: Ptr DescriptorPoolSize) (e) . ($ ())) (poolSizes)
    lift $ poke ((p `plusPtr` 32 :: Ptr (Ptr DescriptorPoolSize))) (pPPoolSizes')
    lift $ f
  cStructSize = 40
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO)
    pNext' <- fmap castPtr . ContT $ withZeroChain @es
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext'
    lift $ poke ((p `plusPtr` 20 :: Ptr Word32)) (zero)
    pPPoolSizes' <- ContT $ allocaBytesAligned @DescriptorPoolSize ((Data.Vector.length (mempty)) * 8) 4
    Data.Vector.imapM_ (\i e -> ContT $ pokeCStruct (pPPoolSizes' `plusPtr` (8 * (i)) :: Ptr DescriptorPoolSize) (e) . ($ ())) (mempty)
    lift $ poke ((p `plusPtr` 32 :: Ptr (Ptr DescriptorPoolSize))) (pPPoolSizes')
    lift $ f

instance PeekChain es => FromCStruct (DescriptorPoolCreateInfo es) where
  peekCStruct p = do
    pNext <- peek @(Ptr ()) ((p `plusPtr` 8 :: Ptr (Ptr ())))
    next <- peekChain (castPtr pNext)
    flags <- peek @DescriptorPoolCreateFlags ((p `plusPtr` 16 :: Ptr DescriptorPoolCreateFlags))
    maxSets <- peek @Word32 ((p `plusPtr` 20 :: Ptr Word32))
    poolSizeCount <- peek @Word32 ((p `plusPtr` 24 :: Ptr Word32))
    pPoolSizes <- peek @(Ptr DescriptorPoolSize) ((p `plusPtr` 32 :: Ptr (Ptr DescriptorPoolSize)))
    pPoolSizes' <- generateM (fromIntegral poolSizeCount) (\i -> peekCStruct @DescriptorPoolSize ((pPoolSizes `advancePtrBytes` (8 * (i)) :: Ptr DescriptorPoolSize)))
    pure $ DescriptorPoolCreateInfo
             next flags maxSets pPoolSizes'

instance es ~ '[] => Zero (DescriptorPoolCreateInfo es) where
  zero = DescriptorPoolCreateInfo
           ()
           zero
           zero
           mempty


-- | VkDescriptorSetAllocateInfo - Structure specifying the allocation
-- parameters for descriptor sets
--
-- == Valid Usage
--
-- -   Each element of @pSetLayouts@ /must/ not have been created with
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_PUSH_DESCRIPTOR_BIT_KHR'
--     set
--
-- -   If any element of @pSetLayouts@ was created with the
--     'Graphics.Vulkan.Core10.Enums.DescriptorSetLayoutCreateFlagBits.DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT'
--     bit set, 'Graphics.Vulkan.Core10.Handles.DescriptorPool' /must/ have
--     been created with the
--     'Graphics.Vulkan.Core10.Enums.DescriptorPoolCreateFlagBits.DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT'
--     flag set
--
-- == Valid Usage (Implicit)
--
-- -   @sType@ /must/ be
--     'Graphics.Vulkan.Core10.Enums.StructureType.STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO'
--
-- -   @pNext@ /must/ be @NULL@ or a pointer to a valid instance of
--     'Graphics.Vulkan.Core12.Promoted_From_VK_EXT_descriptor_indexing.DescriptorSetVariableDescriptorCountAllocateInfo'
--
-- -   The @sType@ value of each struct in the @pNext@ chain /must/ be
--     unique
--
-- -   'Graphics.Vulkan.Core10.Handles.DescriptorPool' /must/ be a valid
--     'Graphics.Vulkan.Core10.Handles.DescriptorPool' handle
--
-- -   @pSetLayouts@ /must/ be a valid pointer to an array of
--     @descriptorSetCount@ valid
--     'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout' handles
--
-- -   @descriptorSetCount@ /must/ be greater than @0@
--
-- -   Both of 'Graphics.Vulkan.Core10.Handles.DescriptorPool', and the
--     elements of @pSetLayouts@ /must/ have been created, allocated, or
--     retrieved from the same 'Graphics.Vulkan.Core10.Handles.Device'
--
-- = See Also
--
-- 'Graphics.Vulkan.Core10.Handles.DescriptorPool',
-- 'Graphics.Vulkan.Core10.Handles.DescriptorSetLayout',
-- 'Graphics.Vulkan.Core10.Enums.StructureType.StructureType',
-- 'allocateDescriptorSets'
data DescriptorSetAllocateInfo (es :: [Type]) = DescriptorSetAllocateInfo
  { -- | @pNext@ is @NULL@ or a pointer to an extension-specific structure.
    next :: Chain es
  , -- | 'Graphics.Vulkan.Core10.Handles.DescriptorPool' is the pool which the
    -- sets will be allocated from.
    descriptorPool :: DescriptorPool
  , -- | @pSetLayouts@ is a pointer to an array of descriptor set layouts, with
    -- each member specifying how the corresponding descriptor set is
    -- allocated.
    setLayouts :: Vector DescriptorSetLayout
  }
  deriving (Typeable)
deriving instance Show (Chain es) => Show (DescriptorSetAllocateInfo es)

instance Extensible DescriptorSetAllocateInfo where
  extensibleType = STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO
  setNext x next = x{next = next}
  getNext DescriptorSetAllocateInfo{..} = next
  extends :: forall e b proxy. Typeable e => proxy e -> (Extends DescriptorSetAllocateInfo e => b) -> Maybe b
  extends _ f
    | Just Refl <- eqT @e @DescriptorSetVariableDescriptorCountAllocateInfo = Just f
    | otherwise = Nothing

instance PokeChain es => ToCStruct (DescriptorSetAllocateInfo es) where
  withCStruct x f = allocaBytesAligned 40 8 $ \p -> pokeCStruct p x (f p)
  pokeCStruct p DescriptorSetAllocateInfo{..} f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO)
    pNext'' <- fmap castPtr . ContT $ withChain (next)
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext''
    lift $ poke ((p `plusPtr` 16 :: Ptr DescriptorPool)) (descriptorPool)
    lift $ poke ((p `plusPtr` 24 :: Ptr Word32)) ((fromIntegral (Data.Vector.length $ (setLayouts)) :: Word32))
    pPSetLayouts' <- ContT $ allocaBytesAligned @DescriptorSetLayout ((Data.Vector.length (setLayouts)) * 8) 8
    lift $ Data.Vector.imapM_ (\i e -> poke (pPSetLayouts' `plusPtr` (8 * (i)) :: Ptr DescriptorSetLayout) (e)) (setLayouts)
    lift $ poke ((p `plusPtr` 32 :: Ptr (Ptr DescriptorSetLayout))) (pPSetLayouts')
    lift $ f
  cStructSize = 40
  cStructAlignment = 8
  pokeZeroCStruct p f = evalContT $ do
    lift $ poke ((p `plusPtr` 0 :: Ptr StructureType)) (STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO)
    pNext' <- fmap castPtr . ContT $ withZeroChain @es
    lift $ poke ((p `plusPtr` 8 :: Ptr (Ptr ()))) pNext'
    lift $ poke ((p `plusPtr` 16 :: Ptr DescriptorPool)) (zero)
    pPSetLayouts' <- ContT $ allocaBytesAligned @DescriptorSetLayout ((Data.Vector.length (mempty)) * 8) 8
    lift $ Data.Vector.imapM_ (\i e -> poke (pPSetLayouts' `plusPtr` (8 * (i)) :: Ptr DescriptorSetLayout) (e)) (mempty)
    lift $ poke ((p `plusPtr` 32 :: Ptr (Ptr DescriptorSetLayout))) (pPSetLayouts')
    lift $ f

instance PeekChain es => FromCStruct (DescriptorSetAllocateInfo es) where
  peekCStruct p = do
    pNext <- peek @(Ptr ()) ((p `plusPtr` 8 :: Ptr (Ptr ())))
    next <- peekChain (castPtr pNext)
    descriptorPool <- peek @DescriptorPool ((p `plusPtr` 16 :: Ptr DescriptorPool))
    descriptorSetCount <- peek @Word32 ((p `plusPtr` 24 :: Ptr Word32))
    pSetLayouts <- peek @(Ptr DescriptorSetLayout) ((p `plusPtr` 32 :: Ptr (Ptr DescriptorSetLayout)))
    pSetLayouts' <- generateM (fromIntegral descriptorSetCount) (\i -> peek @DescriptorSetLayout ((pSetLayouts `advancePtrBytes` (8 * (i)) :: Ptr DescriptorSetLayout)))
    pure $ DescriptorSetAllocateInfo
             next descriptorPool pSetLayouts'

instance es ~ '[] => Zero (DescriptorSetAllocateInfo es) where
  zero = DescriptorSetAllocateInfo
           ()
           zero
           mempty

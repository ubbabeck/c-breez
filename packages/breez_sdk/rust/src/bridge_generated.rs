#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion,
    clippy::unit_arg,
    clippy::double_parens,
    non_snake_case
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`@ 1.43.0.

use crate::api::*;
use flutter_rust_bridge::*;

// Section: imports

use crate::invoice::LNInvoice;
use crate::invoice::RouteHint;
use crate::invoice::RouteHintHop;
use crate::swap::SwapKeys;

// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_init_hsmd(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "init_hsmd",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_storage_path = storage_path.wire2api();
            let api_secret = secret.wire2api();
            move |task_callback| init_hsmd(api_storage_path, api_secret)
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_create_swap(port_: i64) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "create_swap",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || move |task_callback| create_swap(),
    )
}

#[no_mangle]
pub extern "C" fn wire_create_submaring_swap_script(
    port_: i64,
    hash: *mut wire_uint_8_list,
    swapper_pub_key: *mut wire_uint_8_list,
    payer_pub_key: *mut wire_uint_8_list,
    lock_height: i64,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "create_submaring_swap_script",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_hash = hash.wire2api();
            let api_swapper_pub_key = swapper_pub_key.wire2api();
            let api_payer_pub_key = payer_pub_key.wire2api();
            let api_lock_height = lock_height.wire2api();
            move |task_callback| {
                create_submaring_swap_script(
                    api_hash,
                    api_swapper_pub_key,
                    api_payer_pub_key,
                    api_lock_height,
                )
            }
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_encrypt(port_: i64, key: *mut wire_uint_8_list, msg: *mut wire_uint_8_list) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "encrypt",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_key = key.wire2api();
            let api_msg = msg.wire2api();
            move |task_callback| encrypt(api_key, api_msg)
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_decrypt(port_: i64, key: *mut wire_uint_8_list, msg: *mut wire_uint_8_list) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "decrypt",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_key = key.wire2api();
            let api_msg = msg.wire2api();
            move |task_callback| decrypt(api_key, api_msg)
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_parse_invoice(port_: i64, invoice: *mut wire_uint_8_list) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "parse_invoice",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_invoice = invoice.wire2api();
            move |task_callback| parse_invoice(api_invoice)
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_node_pubkey(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "node_pubkey",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_storage_path = storage_path.wire2api();
            let api_secret = secret.wire2api();
            move |task_callback| node_pubkey(api_storage_path, api_secret)
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_add_routing_hints(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
    invoice: *mut wire_uint_8_list,
    hints: *mut wire_list_route_hint,
    new_amount: u64,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "add_routing_hints",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_storage_path = storage_path.wire2api();
            let api_secret = secret.wire2api();
            let api_invoice = invoice.wire2api();
            let api_hints = hints.wire2api();
            let api_new_amount = new_amount.wire2api();
            move |task_callback| {
                add_routing_hints(
                    api_storage_path,
                    api_secret,
                    api_invoice,
                    api_hints,
                    api_new_amount,
                )
            }
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_sign_message(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
    msg: *mut wire_uint_8_list,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "sign_message",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_storage_path = storage_path.wire2api();
            let api_secret = secret.wire2api();
            let api_msg = msg.wire2api();
            move |task_callback| sign_message(api_storage_path, api_secret, api_msg)
        },
    )
}

#[no_mangle]
pub extern "C" fn wire_handle(
    port_: i64,
    storage_path: *mut wire_uint_8_list,
    secret: *mut wire_uint_8_list,
    msg: *mut wire_uint_8_list,
    peer_id: *mut wire_uint_8_list,
    db_id: u64,
) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "handle",
            port: Some(port_),
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_storage_path = storage_path.wire2api();
            let api_secret = secret.wire2api();
            let api_msg = msg.wire2api();
            let api_peer_id = peer_id.wire2api();
            let api_db_id = db_id.wire2api();
            move |task_callback| {
                handle(
                    api_storage_path,
                    api_secret,
                    api_msg,
                    api_peer_id,
                    api_db_id,
                )
            }
        },
    )
}

// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_route_hint {
    ptr: *mut wire_RouteHint,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_route_hint_hop {
    ptr: *mut wire_RouteHintHop,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RouteHint {
    field0: *mut wire_list_route_hint_hop,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_RouteHintHop {
    src_node_id: *mut wire_uint_8_list,
    short_channel_id: u64,
    fees_base_msat: u32,
    fees_proportional_millionths: u32,
    cltv_expiry_delta: u64,
    htlc_minimum_msat: *mut u64,
    htlc_maximum_msat: *mut u64,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

// Section: wrapper structs

// Section: static checks

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_box_autoadd_u64_0(value: u64) -> *mut u64 {
    support::new_leak_box_ptr(value)
}

#[no_mangle]
pub extern "C" fn new_list_route_hint_0(len: i32) -> *mut wire_list_route_hint {
    let wrap = wire_list_route_hint {
        ptr: support::new_leak_vec_ptr(<wire_RouteHint>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_list_route_hint_hop_0(len: i32) -> *mut wire_list_route_hint_hop {
    let wrap = wire_list_route_hint_hop {
        ptr: support::new_leak_vec_ptr(<wire_RouteHintHop>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_uint_8_list_0(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl<T, S> Wire2Api<Option<T>> for *mut S
where
    *mut S: Wire2Api<T>,
{
    fn wire2api(self) -> Option<T> {
        if self.is_null() {
            None
        } else {
            Some(self.wire2api())
        }
    }
}

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}

impl Wire2Api<u64> for *mut u64 {
    fn wire2api(self) -> u64 {
        unsafe { *support::box_from_leak_ptr(self) }
    }
}

impl Wire2Api<i64> for i64 {
    fn wire2api(self) -> i64 {
        self
    }
}

impl Wire2Api<Vec<RouteHint>> for *mut wire_list_route_hint {
    fn wire2api(self) -> Vec<RouteHint> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}

impl Wire2Api<Vec<RouteHintHop>> for *mut wire_list_route_hint_hop {
    fn wire2api(self) -> Vec<RouteHintHop> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}

impl Wire2Api<RouteHint> for wire_RouteHint {
    fn wire2api(self) -> RouteHint {
        RouteHint(self.field0.wire2api())
    }
}

impl Wire2Api<RouteHintHop> for wire_RouteHintHop {
    fn wire2api(self) -> RouteHintHop {
        RouteHintHop {
            src_node_id: self.src_node_id.wire2api(),
            short_channel_id: self.short_channel_id.wire2api(),
            fees_base_msat: self.fees_base_msat.wire2api(),
            fees_proportional_millionths: self.fees_proportional_millionths.wire2api(),
            cltv_expiry_delta: self.cltv_expiry_delta.wire2api(),
            htlc_minimum_msat: self.htlc_minimum_msat.wire2api(),
            htlc_maximum_msat: self.htlc_maximum_msat.wire2api(),
        }
    }
}

impl Wire2Api<u32> for u32 {
    fn wire2api(self) -> u32 {
        self
    }
}

impl Wire2Api<u64> for u64 {
    fn wire2api(self) -> u64 {
        self
    }
}

impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_RouteHint {
    fn new_with_null_ptr() -> Self {
        Self {
            field0: core::ptr::null_mut(),
        }
    }
}

impl NewWithNullPtr for wire_RouteHintHop {
    fn new_with_null_ptr() -> Self {
        Self {
            src_node_id: core::ptr::null_mut(),
            short_channel_id: Default::default(),
            fees_base_msat: Default::default(),
            fees_proportional_millionths: Default::default(),
            cltv_expiry_delta: Default::default(),
            htlc_minimum_msat: core::ptr::null_mut(),
            htlc_maximum_msat: core::ptr::null_mut(),
        }
    }
}

// Section: impl IntoDart

impl support::IntoDart for LNInvoice {
    fn into_dart(self) -> support::DartCObject {
        vec![
            self.payee_pubkey.into_dart(),
            self.payment_hash.into_dart(),
            self.description.into_dart(),
            self.amount.into_dart(),
            self.timestamp.into_dart(),
            self.expiry.into_dart(),
            self.routing_hints.into_dart(),
            self.payment_secret.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for LNInvoice {}

impl support::IntoDart for RouteHint {
    fn into_dart(self) -> support::DartCObject {
        vec![self.0.into_dart()].into_dart()
    }
}
impl support::IntoDartExceptPrimitive for RouteHint {}

impl support::IntoDart for RouteHintHop {
    fn into_dart(self) -> support::DartCObject {
        vec![
            self.src_node_id.into_dart(),
            self.short_channel_id.into_dart(),
            self.fees_base_msat.into_dart(),
            self.fees_proportional_millionths.into_dart(),
            self.cltv_expiry_delta.into_dart(),
            self.htlc_minimum_msat.into_dart(),
            self.htlc_maximum_msat.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for RouteHintHop {}

impl support::IntoDart for SwapKeys {
    fn into_dart(self) -> support::DartCObject {
        vec![
            self.privkey.into_dart(),
            self.pubkey.into_dart(),
            self.preimage.into_dart(),
            self.hash.into_dart(),
        ]
        .into_dart()
    }
}
impl support::IntoDartExceptPrimitive for SwapKeys {}

// Section: executor

support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}

// Section: sync execution mode utility

#[no_mangle]
pub extern "C" fn free_WireSyncReturnStruct(val: support::WireSyncReturnStruct) {
    unsafe {
        let _ = support::vec_from_leak_ptr(val.ptr, val.len);
    }
}

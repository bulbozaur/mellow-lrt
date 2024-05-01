// SPDX-License-Identifier: BSL-1.1
pragma solidity ^0.8.0;

import "../interfaces/validators/IDefaultBondValidator.sol";

import "../utils/DefaultAccessControl.sol";

contract DefaultBondValidator is IDefaultBondValidator, DefaultAccessControl {
    constructor(address admin) DefaultAccessControl(admin) {}

    mapping(address => bool) public isSupportedBond;

    function setSupportedBond(address bond, bool flag) external {
        _requireAdmin();
        isSupportedBond[bond] = flag;
    }

    function validate(address, address, bytes calldata data) external view {
        if (data.length != 0x44) revert InvalidLength();
        bytes4 selector = bytes4(data[:4]);
        if (
            selector == IDefaultBondModule.deposit.selector ||
            selector == IDefaultBondModule.withdraw.selector
        ) {
            (address bond, uint256 amount) = abi.decode(
                data[4:],
                (address, uint256)
            );
            if (!isSupportedBond[bond] || amount == 0) revert Forbidden();
        } else revert Forbidden();
    }
}
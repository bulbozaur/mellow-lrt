// SPDX-License-Identifier: BSL-1.1
pragma solidity ^0.8.21;

import "../modules/obol/IStakingModule.sol";
import "../IVault.sol";

interface ISimpleDVTStakingStrategy {
    error LimitOverflow();

    function vault() external view returns (IVault);

    function stakingModule() external view returns (IStakingModule);

    function maxAllowedRemainder() external view returns (uint256);

    function setMaxAllowedRemainder(uint256 newMaxAllowedRemainder) external;

    function convertAndDeposit(
        uint256 amount,
        uint256 blockNumber,
        bytes32 blockHash,
        bytes32 depositRoot,
        uint256 nonce,
        bytes calldata depositCalldata,
        IDepositSecurityModule.Signature[] calldata sortedGuardianSignatures
    ) external returns (bool success);

    function processWithdrawals(
        address[] memory users,
        uint256 amountForStake
    ) external returns (bool[] memory statuses);

    event MaxAllowedRemainderChanged(
        uint256 newMaxAllowedRemainder,
        address indexed changer
    );

    event ConvertAndDeposit(bool success, address indexed caller);

    event ProcessWithdrawals(
        address[] users,
        uint256 amountForStake,
        address indexed caller
    );
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface AggregatorV3Interface {
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function getRoundData(
        uint80 _roundId
    )
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );
}

library PriceConverter {
    function getLatestPrice(address _address) internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(_address);
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 1e10);
    }

    function getConversionRate(
        uint256 _amount,
        address _address
    ) internal view returns (uint256) {
        uint256 priceOfEther = getLatestPrice(_address);
        uint256 ethAmountInUsd = (priceOfEther * _amount) / 1e18;
        return ethAmountInUsd;
    }
}
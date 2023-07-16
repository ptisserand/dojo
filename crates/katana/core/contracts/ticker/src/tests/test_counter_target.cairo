#[cfg(test)]
#[starknet::interface]
trait ICounterTarget<TContractState> {
    fn tick(ref self: TContractState);
    fn get_counter(self: @TContractState) -> u256;
}

#[cfg(test)]
#[starknet::contract]
mod CounterTarget {
    use starknet::{ContractAddress, get_caller_address};

    #[storage]
    struct Storage {
        ticker: ContractAddress,
        counter: u256
    }

    #[constructor]
    fn constructor(ref self: ContractState) {
        self.ticker.write(get_caller_address());
        self.counter.write(0);
    }

    #[external(v0)]
    impl CounterTarget of super::ICounterTarget<ContractState> {
        fn tick(ref self: ContractState) {
            assert(self.ticker.read() == get_caller_address(), 'Not ticker');
            self.counter.write(self.counter.read() + 1);
        }

        fn get_counter(self: @ContractState) -> u256 {
            self.counter.read()
        }
    }
}
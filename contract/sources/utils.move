module fds::utils {

    use std::string;
    use std::vector;
    #[test_only]
    use std::signer;
    #[test_only]
    use aptos_framework::aptos_coin::AptosCoin;
    #[test_only]
    use aptos_framework::coin;
    #[test_only]
    use aptos_framework::coin::{BurnCapability, FreezeCapability, MintCapability};

    const EINVALID_USERNAME: u64 = 300;

    public fun assert_has_no_special_characters(username: string::String){

        let string_length = string::length(&username);
        assert!(string_length <= 16, EINVALID_USERNAME);
        assert!(string_length >= 1, EINVALID_USERNAME);
        let index_of_empty_string = string::index_of(&username, &string::utf8(b" "));
        assert!(index_of_empty_string == string_length, EINVALID_USERNAME);

        let special_characters = vector::empty<string::String>();
        vector::push_back(&mut special_characters, string::utf8(b"!"));
        vector::push_back(&mut special_characters, string::utf8(b"@"));
        vector::push_back(&mut special_characters, string::utf8(b"#"));
        vector::push_back(&mut special_characters, string::utf8(b"$"));
        vector::push_back(&mut special_characters, string::utf8(b"%"));
        vector::push_back(&mut special_characters, string::utf8(b"^"));
        vector::push_back(&mut special_characters, string::utf8(b"&"));
        vector::push_back(&mut special_characters, string::utf8(b"*"));
        vector::push_back(&mut special_characters, string::utf8(b"("));
        vector::push_back(&mut special_characters, string::utf8(b")"));
        vector::push_back(&mut special_characters, string::utf8(b"-"));
        vector::push_back(&mut special_characters, string::utf8(b"+"));
        vector::push_back(&mut special_characters, string::utf8(b"="));
        vector::push_back(&mut special_characters, string::utf8(b"["));
        vector::push_back(&mut special_characters, string::utf8(b"]"));
        vector::push_back(&mut special_characters, string::utf8(b"{"));
        vector::push_back(&mut special_characters, string::utf8(b"}"));
        vector::push_back(&mut special_characters, string::utf8(b"|"));
        vector::push_back(&mut special_characters, string::utf8(b";"));
        vector::push_back(&mut special_characters, string::utf8(b":"));
        vector::push_back(&mut special_characters, string::utf8(b"'"));
        vector::push_back(&mut special_characters, string::utf8(b"\""));
        vector::push_back(&mut special_characters, string::utf8(b"<"));
        vector::push_back(&mut special_characters, string::utf8(b">"));
        vector::push_back(&mut special_characters, string::utf8(b","));
        vector::push_back(&mut special_characters, string::utf8(b"."));
        vector::push_back(&mut special_characters, string::utf8(b"/"));
        vector::push_back(&mut special_characters, string::utf8(b"?"));
        vector::push_back(&mut special_characters, string::utf8(b"`"));
        vector::push_back(&mut special_characters, string::utf8(b"~"));
        vector::push_back(&mut special_characters, string::utf8(b" "));
        vector::push_back(&mut special_characters, string::utf8(b"\t"));
        vector::push_back(&mut special_characters, string::utf8(b"\n"));
        vector::push_back(&mut special_characters, string::utf8(b"\r"));
        vector::push_back(&mut special_characters, string::utf8(b"\0"));
        vector::push_back(&mut special_characters, string::utf8(b"A"));
        vector::push_back(&mut special_characters, string::utf8(b"B"));
        vector::push_back(&mut special_characters, string::utf8(b"C"));
        vector::push_back(&mut special_characters, string::utf8(b"D"));
        vector::push_back(&mut special_characters, string::utf8(b"E"));
        vector::push_back(&mut special_characters, string::utf8(b"F"));
        vector::push_back(&mut special_characters, string::utf8(b"G"));
        vector::push_back(&mut special_characters, string::utf8(b"H"));
        vector::push_back(&mut special_characters, string::utf8(b"I"));
        vector::push_back(&mut special_characters, string::utf8(b"J"));
        vector::push_back(&mut special_characters, string::utf8(b"K"));
        vector::push_back(&mut special_characters, string::utf8(b"L"));
        vector::push_back(&mut special_characters, string::utf8(b"M"));
        vector::push_back(&mut special_characters, string::utf8(b"N"));
        vector::push_back(&mut special_characters, string::utf8(b"O"));
        vector::push_back(&mut special_characters, string::utf8(b"P"));
        vector::push_back(&mut special_characters, string::utf8(b"Q"));
        vector::push_back(&mut special_characters, string::utf8(b"R"));
        vector::push_back(&mut special_characters, string::utf8(b"S"));
        vector::push_back(&mut special_characters, string::utf8(b"T"));
        vector::push_back(&mut special_characters, string::utf8(b"U"));
        vector::push_back(&mut special_characters, string::utf8(b"V"));
        vector::push_back(&mut special_characters, string::utf8(b"W"));
        vector::push_back(&mut special_characters, string::utf8(b"X"));
        vector::push_back(&mut special_characters, string::utf8(b"Y"));
        vector::push_back(&mut special_characters, string::utf8(b"Z"));

        let current_index = 0;
        let special_characters_length = vector::length(&special_characters);
        while(current_index < special_characters_length) {
            let special_character = vector::borrow(&special_characters, current_index);
            let index_of_special_character = string::index_of(&username, special_character);
            assert!(index_of_special_character == string_length, EINVALID_USERNAME);
            current_index = current_index + 1;
        }

    }

    #[test_only]
    public fun initialize_coin(aptos: signer, admin: &signer, operator: &signer, user: &signer): (BurnCapability<AptosCoin>, FreezeCapability<AptosCoin>, MintCapability<AptosCoin>){

        let (burn_cap, freeze_cap,mint_cap) = coin::initialize<AptosCoin>(&aptos,string::utf8(b"Aptos"), string::utf8(b"APT"), 8, false);

        coin::register<AptosCoin>(operator);
        coin::register<AptosCoin>(user);
        coin::register<AptosCoin>(admin);
        let coins_operator = coin::mint<AptosCoin>(100_000_000_00, &mint_cap);
        coin::deposit(signer::address_of(operator), coins_operator);
        let coins_user = coin::mint<AptosCoin>(100_000_000_00, &mint_cap);
        coin::deposit(signer::address_of(user), coins_user);

        (burn_cap, freeze_cap, mint_cap)
    }

    #[test_only]
    public fun destroy_coin(burn: BurnCapability<AptosCoin>, freeze: FreezeCapability<AptosCoin>, mint: MintCapability<AptosCoin>){
        coin::destroy_mint_cap(mint);
        coin::destroy_freeze_cap(freeze);
        coin::destroy_burn_cap(burn);
    }

    #[test_only]
    public fun testing_identifiers(): (string::String, string::String) {
        let username = string::utf8(b"denv");
        let namespace = string::utf8(b"kade");

        (username, namespace)
    }
}

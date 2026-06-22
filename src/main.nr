use dep::std;

fn main(
    private_inputs: [Field; 4], 
    pub_model_weights: [Field; 4],
    pub_bias: Field,
    pub_expected_activation: Field 
) {
    let mut accumulator: Field = 0;

    // 1. Compute the ML Dot Product Matrix
    for i in 0..4 {
        accumulator += private_inputs[i] * pub_model_weights[i];
    }

    // 2. Apply network bias
    accumulator += pub_bias;

    // 3. Safe Type-Cast Activation Check for Field overflow
    let is_active = (accumulator as u32) > 100;

    // 4. Enforce verifiable state transformation
    assert(is_active as Field == pub_expected_activation);
}

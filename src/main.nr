use dep::std;

fn main(
    private_inputs: [Field; 4], 
    pub_model_weights: [Field; 4],
    pub_bias: Field,
    pub_expected_activation: Field 
) {
    let mut accumulator: Field = 0;

    for i in 0..4 {
        accumulator += private_inputs[i] * pub_model_weights[i];
    }

    accumulator += pub_bias;

    let is_active = (accumulator as u32) > 100;

    assert(is_active as Field == pub_expected_activation);
}

use dep::std;

// A constrained zkML perceptron running natively on mobile
fn main(
    // Private: The user's raw device/sensor data
    private_inputs: [Field; 4], 
    
    // Public: The trained model's quantized weights
    pub_model_weights: [Field; 4],
    
    // Public: The model's bias
    pub_bias: Field,
    
    // Public: Expected threshold/classification result
    pub_expected_activation: Field 
) {
    let mut accumulator: Field = 0;

    // 1. Matrix Multiplication (Dot Product)
    // Computing the ML inference entirely inside the constraint system
    for i in 0..4 {
        accumulator += private_inputs[i] * pub_model_weights[i];
    }

    // 2. Add bias
    accumulator += pub_bias;

    // 3. Activation Function (ReLU equivalent for ZK fields)
    // If accumulator is less than a certain threshold, we zero it out, otherwise keep it.
    // For simplicity in a Field, we use a strict equality or bounds check.
    let is_active = accumulator as u32 > 100; // 100 is an arbitrary activation threshold

    // 4. Constrain the output
    // Proving the inference evaluated exactly as expected
    assert(is_active as Field == pub_expected_activation);
}


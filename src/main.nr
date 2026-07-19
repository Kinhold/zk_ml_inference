fn main(
    private_inputs: [Field; 4],
    model_weights: pub [Field; 4],
    bias: pub Field,
    expected_activation: pub Field,
) {
    let mut accumulator: Field = 0;

    for i in 0..4 {
        accumulator += private_inputs[i] * model_weights[i];
    }

    accumulator += bias;

    let is_active = (accumulator as u32) > 100;

    assert(is_active as Field == expected_activation);
}

#[test]
fn test_active_score() {
    main([10, 20, 30, 40], [2, 1, 1, 1], 5, 1);
}

#[test]
fn test_inactive_score() {
    main([10, 20, 30, 40], [1, 0, 0, 0], 5, 0);
}

#[test]
fn test_threshold_is_inactive() {
    main([100, 0, 0, 0], [1, 0, 0, 0], 0, 0);
}

#[test]
fn test_one_above_threshold_is_active() {
    main([101, 0, 0, 0], [1, 0, 0, 0], 0, 1);
}

#[test(should_fail)]
fn test_rejects_incorrect_activation() {
    main([101, 0, 0, 0], [1, 0, 0, 0], 0, 0);
}

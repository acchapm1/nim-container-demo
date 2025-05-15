curl -X POST \
  -F "input_array=@corrdiff_inputs.npy" \
  -F "samples=2" \
  -F "steps=12" \
  -o output.tar \
  http://localhost:8000/v1/infer

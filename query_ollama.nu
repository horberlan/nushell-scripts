# query_ollama "What is the capital of France?" model? = llama3.2-vision:latest
def query_ollama [prompt: string, model: string = "llama3.2-vision:latest"] {
  let data = {
    model: $model,
    prompt: $prompt,
    stream: false
  }
  let query_ollama_url = "http://localhost:11434/api/generate"

  let response = http post $query_ollama_url --content-type application/json ($data | to json)
  | from json
  
  if ($response | get error? | is-empty) {
    $response | get response
  } else {
    $"Error: ($response | get error)"
  }
}
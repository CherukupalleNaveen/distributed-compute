from transformers import AutoTokenizer
from petals import AutoDistributedModelForCausalLM

# Choose any model available at https://health.petals.dev
model_name = "bigscience/bloomz-560m"  # This one is fine-tuned Llama 2 (70B)
INITIAL_PEERS = ['/ip4/65.108.151.120/tcp/31337/p2p/QmbPdbE4bsjPGEV7KDepxPFBqmRtQuK479LVi8qvB8seL1']

# Connect to a distributed network hosting model layers
tokenizer = AutoTokenizer.from_pretrained(model_name)
model = AutoDistributedModelForCausalLM.from_pretrained(model_name, initial_peers=INITIAL_PEERS)

# Run the model as if it were on your computer
inputs = tokenizer("A cat sat", return_tensors="pt")["input_ids"]
outputs = model.generate(inputs, max_new_tokens=50)
print(tokenizer.decode(outputs[0]))  # A cat sat on a mat...
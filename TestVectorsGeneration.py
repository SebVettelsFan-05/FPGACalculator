
def generate_testvectors (num_of_bytes):
    num_of_vectors = 2**(num_of_bytes)
    for i in range (0,num_of_vectors):
        print(bin(i)[2:].zfill(num_of_bytes)+"_")

generate_testvectors(4)
    


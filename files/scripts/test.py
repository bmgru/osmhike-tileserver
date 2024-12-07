###########################################################################
# small script to help understand the result of yaml syntax 
###########################################################################


with open("test.yml","r") as file:
    z=yaml.safe_load(file)
print(z)

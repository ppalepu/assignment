def get_value(object : dict,key : str) -> str :
    val=object
    for i in key.split('/'): 
     if i!='' :
       try:
         val=val[i]
       except KeyError: # this catch is for wrong key strings
         val="Unknown key string"  
         break
       except TypeError as e: # this catch is for wrong/unexpected objects
         if str(e)=="string indices must be integers" :  
          val="Unexpected object" 
         break 
       except: # this is for rest all unknown errors
         val="Error"  
         print("Unknown Error")
         break  
     else: # this is for keys having extra backslash at the end
      val="wrong key standards"    
    return val  

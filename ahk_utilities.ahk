; Custom Utilities

; Join an array together with commas by default, but any seperator may be used
Join(p,s:=", "){
  for k,v in p
  {
    if isobject(v)
      for k2, v2 in v
        o.=s v2
    else
      o.=s v
  }
  return SubStr(o,StrLen(s)+1)
}

; Does array (a) include value (v) ?
Includes(a,v){
  for i, e in a
    if(e = v)
      return i
  return 0
}

; Is the Object an array?
IsArray(obj){
  return !! obj.MaxIndex()
}

; Tests a variable to see if it is Blank or Zero. Returns 0 if the variable has not been set.
IsSet(v){
  isAVar := !v ? 0 : 1
  return isAVar
}

//GLSL
#version 110
uniform sampler2D colorTex;
uniform sampler2D blurTex;
uniform sampler2D blurTex2;
uniform sampler2D auxTex;
uniform sampler2D noiseTex;
uniform sampler2D glareTex;
uniform sampler2D flareTex;

void main() 
    {
    vec2 uv=gl_TexCoord[0].xy;    
    vec2 time_uv=gl_TexCoord[1].xy;
    
    vec4 blured_aux=texture2D(blurTex,uv);
    float shadow=blured_aux.g*0.5+0.5;
    
    vec4 aux=texture2D(auxTex, uv);
    float fogfactor=aux.r;    
    float specfactor=aux.b+blured_aux.b;
    float distor=aux.a;  
    
    vec2 noise=texture2D(noiseTex,time_uv).rg*2.0 - 1.0;    
    vec4 color=texture2D(colorTex,uv+noise*0.01)*distor;    
    color+=texture2D(colorTex,uv)*(1.0-distor);
    color*=shadow;
    color=mix(color, texture2D(blurTex2, uv), fogfactor);
    //vec4 color=vec4(0.0, 0.0, 0.0, 0.0);
    color+=texture2D(glareTex,uv);  
    color+=texture2D(flareTex,uv);     
    
    gl_FragColor =color;
    }
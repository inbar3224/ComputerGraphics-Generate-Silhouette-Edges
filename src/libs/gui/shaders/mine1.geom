#version 330 core

layout(triangles_adjacency) in;
layout(triangle_strip, max_vertices = 12) out;

uniform float HalfWidth;
uniform float OverhangLength;
out float gDist;
out vec3 gSpine;

in vec3 FragPos[6]; // maybe 252
in vec3 Normal[6]; // maybe 252
in vec2 TexCoords[6]; // maybe 252
out vec3 geo_FragPos;
out vec3 geo_Normal;
out vec3 geo_TexCoords;

bool IsFront(vec3 A, vec3 B, vec3 C) {
    float area = (A.x * B.y - B.x * A.y) + (B.x * C.y - C.x * B.y) + (C.x * A.y - A.x * C.y);
    return area > 0;
}

void EmitEdge(vec3 P0, vec3 P1) {
    vec3  E = OverhangLength * vec3(P1.xy - P0.xy, 0);
    vec2  V = normalize(E.xy);
    vec3  N = vec3(-V.y, V.x, 0) * HalfWidth;
    
    gSpine = (P0 + 1.0) * 0.5;
    gDist = +HalfWidth;
    gl_Position = vec4(P0 - N - E, 1); EmitVertex();
    gDist = -HalfWidth;
    gl_Position = vec4(P0 + N - E, 1); EmitVertex();
    gSpine = (P1 + 1.0) * 0.5;
    gDist = +HalfWidth;
    gl_Position = vec4(P1 - N + E, 1); EmitVertex();
    gDist = -HalfWidth;
    gl_Position = vec4(P1 + N + E, 1); EmitVertex();
    EndPrimitive();    
}

//void EmitEdge(vec3 P0, vec3 P1) {
  //  vec3  E = OverhangLength * vec3(P1.xy - P0.xy, 0);
    //vec2  V = normalize(E.xy);
   // vec3  N = vec3(-V.y, V.x, 0) * HalfWidth;
   // vec3  S = -N;
   // float D = HalfWidth;

    //gSpine = P0;
    //gl_Position = vec4(P0 + S - E, 1); gDist = +D; EmitVertex();
 	//gl_Position = vec4(P0 + N - E, 1); gDist = -D; EmitVertex();
   // gSpine = P1;
 //	gl_Position = vec4(P1 + S + E, 1); gDist = +D; EmitVertex();
   // gl_Position = vec4(P1 + N + E, 1); gDist = -D; EmitVertex();
   // EndPrimitive();
//}

void main() {
    vec3 v0 = gl_in[0].gl_Position.xyz / gl_in[0].gl_Position.w;
    vec3 v1 = gl_in[1].gl_Position.xyz / gl_in[1].gl_Position.w;
    vec3 v2 = gl_in[2].gl_Position.xyz / gl_in[2].gl_Position.w;
    vec3 v3 = gl_in[3].gl_Position.xyz / gl_in[3].gl_Position.w;
    vec3 v4 = gl_in[4].gl_Position.xyz / gl_in[4].gl_Position.w;
    vec3 v5 = gl_in[5].gl_Position.xyz / gl_in[5].gl_Position.w;
    
    if (IsFront(v0, v2, v4)) {
        if (!IsFront(v0, v1, v2)) EmitEdge(v0, v2);
        if (!IsFront(v2, v3, v4)) EmitEdge(v2, v4);
        if (!IsFront(v0, v4, v5)) EmitEdge(v4, v0);
    }
    
    for(int i = 0; i < 6; i++) {
        geo_FragPos = FragPos[i];
        EmitVertex();    
        geo_Normal = Normal[i];
        EmitVertex();
        geo_TexCoords = TexCoords[i];
        EmitVertex();
    }    
}
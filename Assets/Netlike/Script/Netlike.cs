using UnityEngine;
using System.Collections;

public class Netlike : MonoBehaviour {

    public int PixelPenetrateCount = 1;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
        Shader.SetGlobalInt("global_pixel_penetrate_count", PixelPenetrateCount);
	}
}

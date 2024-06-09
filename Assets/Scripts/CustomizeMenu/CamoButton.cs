using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CamoButton : MonoBehaviour
{

    [SerializeField] private Material camoMaterial;

    [SerializeField] private int materialID;
    public Material GetMaterial()
    {
        return camoMaterial;
    }

    public int GetMaterialID()
    {
        return materialID;
    }
}

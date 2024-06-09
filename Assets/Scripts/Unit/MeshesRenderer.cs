using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MeshesRenderer : MonoBehaviour
{
    [SerializeField] private List<GameObject> bodyMeshes;
    [SerializeField] private List<GameObject> extraGear;
    [SerializeField] private List<GameObject> headMeshes;
    [SerializeField] private List<GameObject> legMeshes;


    private List<GameObject> GetBodyMeshes()
    {
        return bodyMeshes;
    }
    private List<GameObject> GetExtraGearMeshes()
    {
        return extraGear;
    }
    private List<GameObject> GetHeadMeshes()
    {
        return headMeshes;
    }
    private List<GameObject> GetLegsMeshes()
    {
        return legMeshes;
    }
}

using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UnitData : MonoBehaviour
{

    [Header("UI Data")]
    [SerializeField] private Sprite avatar;
    [SerializeField] private string name;

    [SerializeField] private GameObject gunGameObject;

    public List<int> camouflageIndexList;

    private void Start()
    {
        InitializeList();
    }

    private void InitializeList()
    {
        camouflageIndexList = new List<int>(5);
        camouflageIndexList.Add(0);
        camouflageIndexList.Add(0);
        camouflageIndexList.Add(0);
        camouflageIndexList.Add(0);
        camouflageIndexList.Add(0);
    }

    public Sprite GetAvatar()
    {
        return avatar;
    }

    public string GetName()
    {
        return name;
    }

    public GameObject GetGunGameObject()
    {
        return gunGameObject;
    }

    public void SetGunGameObject(GameObject gun)
    {
        gunGameObject = gun;
    }

    public List<int> GetCamoIndexList()
    {
        return camouflageIndexList;
    }
}

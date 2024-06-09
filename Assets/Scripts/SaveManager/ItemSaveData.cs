using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class ItemSaveData
{
    public int outfitID;
    public int camouflageID;

    public ItemSaveData(int outfitID, int camouflageID)
    {
        this.outfitID = outfitID;
        this.camouflageID = camouflageID;
    }
}

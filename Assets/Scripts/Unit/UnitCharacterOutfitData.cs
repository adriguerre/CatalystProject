using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[Serializable]
public class UnitCharacterOutfitData
{

    public List<int> unlockedItemsID;

    public Dictionary<int, ItemSaveData> outfitsIDWithCamoDictionary;

    public UnitCharacterOutfitData(bool aux)
    {
        outfitsIDWithCamoDictionary = new Dictionary<int, ItemSaveData>();
        unlockedItemsID = new List<int>();
    }
    public UnitCharacterOutfitData()
    {
        outfitsIDWithCamoDictionary = new Dictionary<int, ItemSaveData>();
        unlockedItemsID = new List<int>();
        unlockedItemsID.Add(0);
        unlockedItemsID.Add(11);
        unlockedItemsID.Add(14);
        unlockedItemsID.Add(17);
        unlockedItemsID.Add(69);
    }
}

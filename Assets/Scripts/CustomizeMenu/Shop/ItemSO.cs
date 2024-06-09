using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[CreateAssetMenu(fileName = "Data", menuName = "ScriptableObjects/Item", order = 1)]
public class ItemSO : ScriptableObject
{

    public bool unlocked = false;
    public int itemPrice;
    public Sprite itemSprite;
    public string itemName;
    public int itemID;
}

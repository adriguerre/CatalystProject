using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using Newtonsoft.Json;
using UnityEngine;

public class SaveManager : MonoBehaviour
{
    private string _dataDirPath;
    private string dataFileName = "";

    public static SaveManager Instance;

    private void Awake()
    {
        if (Instance != null)
        {
            Debug.LogWarning("[[SaveManager]] :: There is already a saver Manager on the scene");
            Destroy(this);
        }

        Instance = this; 
    }


    public void SavePlayerOutfitJson(int soldierIndex, UnitCharacterOutfitData data)
    {
        
        //Create Folder
        _dataDirPath = Application.persistentDataPath;
        string fullPath = Path.Combine(_dataDirPath, "soldiers", "player_" + soldierIndex);
        Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
        
        string json = JsonConvert.SerializeObject(data);
        Debug.Log(json);
        using (StreamWriter streamWriter = new StreamWriter(fullPath))
        {
            streamWriter.Write(json);
        }
    }
    
    public void SaveNewItemUnlockedInSoldier(int soldierIndex, List<int> newObjectUnlocked)
    {
        _dataDirPath = Application.persistentDataPath;
        string fullPath = Path.Combine(_dataDirPath,"soldiers", "player_" + soldierIndex);
        UnitCharacterOutfitData dataObject = new UnitCharacterOutfitData(true);
        try
        {
            Directory.CreateDirectory(Path.GetDirectoryName(fullPath));
            using (StreamReader streamReader = new StreamReader(fullPath))
            {
                string jsonFromFile = streamReader.ReadToEnd();
                dataObject = JsonConvert.DeserializeObject<UnitCharacterOutfitData>(jsonFromFile);
            }
        }
        catch (FileNotFoundException error)
        {
            Debug.Log("FILE NOT FOUND - WE DONT HAVE AVAILABLE DATA FOR THIS CHARACTER");
        }

        foreach (int item in newObjectUnlocked)
        {
            dataObject.unlockedItemsID.Add(item);
        }

        string json = JsonConvert.SerializeObject(dataObject);;
        Debug.Log(json);
        using (StreamWriter streamWriter = new StreamWriter(fullPath))
        {
            streamWriter.Write(json);
        }
    }

    public UnitCharacterOutfitData TryLoadPlayerOutfitJson(int soldierIndex)
    {
        try
        {
            _dataDirPath = Application.persistentDataPath;
            string fullPath = Path.Combine(_dataDirPath, "soldiers", "player_" + soldierIndex);
            Directory.CreateDirectory(Path.GetDirectoryName(fullPath));

            using (StreamReader streamReader = new StreamReader(fullPath))
            {
                string jsonFromFile = streamReader.ReadToEnd();
                return JsonConvert.DeserializeObject<UnitCharacterOutfitData>(jsonFromFile);
                // JsonUtility.FromJsonOverwrite(jsonFromFile, dataObject);
                
            }

        }
        catch (Exception error)
        {
            Debug.Log("ERROR: " + error);
            return null;
        }

        return null;
    }
}

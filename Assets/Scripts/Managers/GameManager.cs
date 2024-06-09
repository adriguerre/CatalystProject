using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GameManager : MonoBehaviour
{

    public static GameManager Instance; 
    
    [Header("Spawning Positions")] 
    [SerializeField] private List<Transform> spawnLocations;

    [Header("Characters Prefabs")] 
    [SerializeField] private List<GameObject> soldiersPrefabs;
    [SerializeField] private GameObject soldierUIPrefab;

    [SerializeField] private GameObject squadUI;

    [SerializeField] private GameObject soldierActionsUI;

    [SerializeField] private List<Soldier> soldiersList;
    private void Awake()
    {
        if (Instance != null)
        {
            Destroy(this);
        }

        Instance = this;
    }

    void Start()
    {
        StartGame();
        soldierActionsUI.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    public void StartGame()
    {
        for (int i = 0; i < spawnLocations.Count; i++)
        {
            GameObject soldier = Instantiate(soldiersPrefabs[i], spawnLocations[i].position, Quaternion.identity);
            UnitData unitData = soldier.GetComponent<UnitData>();
            Soldier soldierScript = soldier.GetComponentInChildren<Soldier>();
            GameObject soldierUI = Instantiate(soldierUIPrefab, new Vector3(0, 0, 0), Quaternion.identity, squadUI.transform);
            UnitsBar unitBarUI = soldierUI.GetComponent<UnitsBar>();
            unitBarUI.SetUpUnitUI(unitData.GetName(), unitData.GetAvatar());
            UnitHealth unitHealth = soldier.GetComponent<UnitHealth>();
            unitHealth.SetUnitHealthUI(unitBarUI);
            soldierScript.SetUnitHealtScript(unitHealth);
            
            AddSoldierToList(soldierScript);
        }
    }

    public void ActivateSoldierActions(Vector3 position)
    {
        soldierActionsUI.transform.position = position;
        soldierActionsUI.SetActive(true);
    }

    public void ActDesSoldierActions(Vector3 position)
    {
        soldierActionsUI.transform.position = position;
        soldierActionsUI.SetActive(!soldierActionsUI.activeSelf);  
    }
    
    public void DesactivateSoldierActions()
    {
        soldierActionsUI.SetActive(false);
    }

    public void AddSoldierToList(Soldier soldier)
    {
        soldiersList.Add(soldier);
    }

    public void ClearAllSoldierStatus()
    {
        foreach (Soldier soldier in soldiersList)
        {
            soldier.SetAvalilableSoldierActionsUI(false);
        }
    }
    
    
}

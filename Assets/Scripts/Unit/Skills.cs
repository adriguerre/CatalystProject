using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Skills : MonoBehaviour
{

    /*
     * Level From 1 [Recruit] to 3 [Elite] //TODO: Need balancing
     */
    [Header("Expert Marksman")]
    [SerializeField] private int expertMarksmanLevel;
    private float _expertMarksmanProgress;
    [Header("Advanced Camouflage")]
    [SerializeField] private int advancedCamouflageLevel;
    private float _advancedCamouflageProgress;
    [Header("Quick Reloader")]
    [SerializeField] private int quickReloaderLevel;
    private float _quickReloaderProgress;
    [Header("Relience")]
    [SerializeField] private int resilienceLevel;
    private float _resilienceProgress;
    [Header("Swift Healer")]
    [SerializeField] private int swiftHealerLevel;
    private float _swiftHealerProgress;
    [Header("Stealthy")]
    [SerializeField] private int stealthyLevel;
    private float _stealthyProgress;
    [Header("Enhanced Reflexes")]
    [SerializeField] private int enhancedReflexesLevel;
    private float _enhancedReflexesProgress;
    
    
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
